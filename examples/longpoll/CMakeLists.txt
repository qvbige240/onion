include_directories (${PROJECT_SOURCE_DIR}/src/)
add_executable(longpoll longpoll.c)
target_link_libraries(longpoll onion_static)

add_executable(longpoll-async longpoll-async.c)
target_link_libraries(longpoll-async onion_static)
