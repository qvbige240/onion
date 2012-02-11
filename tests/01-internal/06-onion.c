/*
	Onion HTTP server library
	Copyright (C) 2010 David Moreno Montero

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Affero General Public License as
	published by the Free Software Foundation, either version 3 of the
	License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Affero General Public License for more details.

	You should have received a copy of the GNU Affero General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
	*/

#include <onion/log.h>
#include <malloc.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <curl/curl.h>

#include <onion/onion.h>

#include "../ctest.h"
#include <pthread.h>

const int MAX_TIME=120;

char processed;
volatile char okexit=0;
onion *o;
FILE *null_file=NULL;

typedef struct{
  float wait_s;
  float wait_t;
  int n_requests;
  char close_at_n;
}params_t;

onion_response_codes process_request(void *_, onion_request *req, onion_response *res){
  processed++;
  onion_response_write0(res, "Done");
  
  return OCS_PROCESSED;
}

int curl_get(const char *url){
  if (!null_file)
    null_file=fopen("/dev/null","w");
  FAIL_IF(null_file == NULL);
  CURL *curl;
  curl = curl_easy_init();
  FAIL_IF_NOT(curl_easy_setopt(curl, CURLOPT_URL, url)==CURLE_OK);
  FAIL_IF_NOT(curl_easy_setopt(curl, CURLOPT_WRITEDATA, null_file)==CURLE_OK);
  CURLcode res=curl_easy_perform(curl);
  FAIL_IF_NOT_EQUAL((int)res,0);
  long int http_code;
  res=curl_easy_getinfo(curl, CURLINFO_HTTP_CODE, &http_code);
  FAIL_IF_NOT_EQUAL((int)res,0);
  char buffer[1024]; size_t l;
  curl_easy_recv(curl,buffer,sizeof(buffer),&l);
  curl_easy_cleanup(curl);
  FAIL_IF_NOT_EQUAL_INT((int)http_code, HTTP_OK);
  
  return 0;
}

void *do_requests(params_t *t){
  int i;
  usleep(t->wait_s*1000000);
  for(i=0;i<t->n_requests;i++){
    curl_get("http://localhost:8080/");
    usleep(t->wait_t*1000000);
  }
  if (t->close_at_n)
    onion_listen_stop(o);
  
  return NULL;
}

void *watchdog(void *_){
  sleep(MAX_TIME);
  if (!okexit){
    ONION_ERROR("Error! Waiting too long, server must have deadlocked!");
    exit(1);
  }
  return NULL;
}

void do_petition_set(float wait_s, float wait_c, int n_requests, char close){
  processed=0;
  
  params_t params;
  params.wait_s=wait_s;
  params.wait_t=wait_c;
  params.n_requests=n_requests;
  params.close_at_n=close;
  
  pthread_t thread;
  pthread_create(&thread, NULL, (void*)do_requests, &params);
  onion_listen(o);
  pthread_join(thread, NULL);
  
  FAIL_IF_NOT_EQUAL_INT(params.n_requests, processed);
}

void t01_server_one(){
  INIT_LOCAL();
  
  o=onion_new(O_ONE);
  onion_set_root_handler(o,onion_handler_new((void*)process_request,NULL,NULL));
  do_petition_set(1,0.1,1,0);
  onion_free(o);
  
  o=onion_new(O_ONE_LOOP);
  onion_set_root_handler(o,onion_handler_new((void*)process_request,NULL,NULL));
  do_petition_set(1,0.1,1,1);
  onion_free(o);
  
  o=onion_new(O_ONE_LOOP);
  onion_set_root_handler(o,onion_handler_new((void*)process_request,NULL,NULL));
  do_petition_set(1,0.001,100,1);
  onion_free(o);
  
  END_LOCAL();
}

void t02_server_epoll(){
  INIT_LOCAL();
  
  o=onion_new(O_POLL);
  onion_set_root_handler(o,onion_handler_new((void*)process_request,NULL,NULL));
  do_petition_set(1,0.1,1,1);
  onion_free(o);
  
  END_LOCAL();
}

int main(int argc, char **argv){
  START();
  pthread_t watchdog_thread;
  pthread_create(&watchdog_thread, NULL, (void*)watchdog, NULL);
  
  t01_server_one();
  t02_server_epoll();
  
  okexit=1;
  pthread_cancel(watchdog_thread);
  pthread_join(watchdog_thread,NULL);
  
  if (null_file)
    fclose(null_file);
  
	END();
}

