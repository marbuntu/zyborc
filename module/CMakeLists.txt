
if (CONFIG_ZYBORC)
    zephyr_include_directories(include)
    zephyr_library_sources(
        src/test.c
    )
endif()