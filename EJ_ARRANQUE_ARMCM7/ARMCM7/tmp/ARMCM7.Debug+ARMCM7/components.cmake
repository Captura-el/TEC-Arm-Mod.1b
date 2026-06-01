# components.cmake

# component ARM::CMSIS:CORE@6.2.0
add_library(ARM_CMSIS_CORE_6_2_0 INTERFACE)
target_include_directories(ARM_CMSIS_CORE_6_2_0 INTERFACE
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_INCLUDE_DIRECTORIES>
  "${CMSIS_PACK_ROOT}/ARM/CMSIS/6.3.0/CMSIS/Core/Include"
)
target_compile_definitions(ARM_CMSIS_CORE_6_2_0 INTERFACE
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_COMPILE_DEFINITIONS>
)
target_link_libraries(ARM_CMSIS_CORE_6_2_0 INTERFACE
  ${CONTEXT}_ABSTRACTIONS
)

# component ARM::Device:Startup&C Startup@2.2.0
add_library(ARM_Device_Startup_C_Startup_2_2_0 OBJECT
  "${SOLUTION_ROOT}/ARMCM7/RTE/Device/ARMCM7/startup_ARMCM7.c"
  "${SOLUTION_ROOT}/ARMCM7/RTE/Device/ARMCM7/system_ARMCM7.c"
)
target_include_directories(ARM_Device_Startup_C_Startup_2_2_0 PUBLIC
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_INCLUDE_DIRECTORIES>
  "${CMSIS_PACK_ROOT}/ARM/Cortex_DFP/1.1.0/Device/ARMCM7/Include"
)
target_compile_definitions(ARM_Device_Startup_C_Startup_2_2_0 PUBLIC
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_COMPILE_DEFINITIONS>
)
target_compile_options(ARM_Device_Startup_C_Startup_2_2_0 PUBLIC
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_COMPILE_OPTIONS>
)
target_link_libraries(ARM_Device_Startup_C_Startup_2_2_0 PUBLIC
  ${CONTEXT}_ABSTRACTIONS
)
