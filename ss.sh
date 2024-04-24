#!/bin/bash
        if [ -n "${PARAM_OVERRIDE_ARGS}" ]; then
          echo "override-args parameter was supplied; orb defaults will be overridden"
          emulator -avd ${PARAM_AVD_NAME} ${PARAM_OVERRIDE_ARGS}
        else
          if [ "${PARAM_NO_WINDOW}" -eq 1 ]; then
            set -- "$@" -no-window
          fi
          if [ "${PARAM_NO_AUDIO}" -eq 1 ]; then
            set -- "$@" -no-audio
          fi
          if [ "${PARAM_NO_BOOT_ANIM}" -eq 1 ]; then
            set -- "$@" -no-boot-anim
          fi
          if [ "${PARAM_VERBOSE}" -eq 1 ]; then
            set -- "$@" -verbose
          fi
          if [ "${PARAM_NO_SNAPSHOT}" -eq 1 ]; then
            set -- "$@" -no-snapshot
          fi
          if [ "${PARAM_DELAY_ABD}" -eq 1 ]; then
            set -- "$@" -delay-adb
          fi
          if [ "${PARAM_MEMORY}" != "-1" ]; then
            set -- "$@" -memory ${PARAM_MEMORY}
          fi
          if [ -n "${PARAM_GPU}" ]; then
            set -- "$@" -gpu "${PARAM_GPU}"
          fi
          if [ -n "${PARAM_CAMERA_FRONT}" ]; then
            set -- "$@" -camera-front "${PARAM_CAMERA_FRONT}"
          fi
          if [ -n "${PARAM_CAMERA_BACK}" ]; then
            set -- "$@" -camera-back "${PARAM_CAMERA_BACK}"
          fi
          echo "Starting emulator with arguments $* ${PARAM_ADDITIONAL_ARGS}"
          emulator -avd ${PARAM_AVD_NAME} "$@" ${PARAM_ADDITIONAL_ARGS}
        fi