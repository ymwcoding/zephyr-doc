:orphan:

.. title:: UART_STM32_PORT_2_NAME

.. option:: CONFIG_UART_STM32_PORT_2_NAME:
.. _CONFIG_UART_STM32_PORT_2_NAME:

This is the device name for USART3 port, and is
included in the device struct.



:Symbol:           UART_STM32_PORT_2_NAME
:Type:             string
:Value:            ""
:User value:       (no user value)
:Visibility:       "n"
:Is choice item:   false
:Is defined:       true
:Is from env.:     false
:Is special:       false
:Prompts:

 *  "Device Name for STM32 USART1 Port" if UART_STM32_PORT_2 (value: "n")
:Default values:

 *  "UART_2"
 *   Condition: UART_STM32_PORT_2 (value: "n")
:Selects:
 (no selects)
:Reverse (select-related) dependencies:
 (no reverse dependencies)
:Additional dependencies from enclosing menus and ifs:
 SERIAL (value: "n")
:Locations:
 * ../drivers/serial/Kconfig.stm32:102