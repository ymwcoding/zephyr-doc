:orphan:

.. title:: LOAPIC_TIMER_IRQ_PRIORITY

.. option:: CONFIG_LOAPIC_TIMER_IRQ_PRIORITY:
.. _CONFIG_LOAPIC_TIMER_IRQ_PRIORITY:

This options specifies the IRQ priority used by the LOAPIC timer.



:Symbol:           LOAPIC_TIMER_IRQ_PRIORITY
:Type:             int
:Value:            ""
:User value:       (no user value)
:Visibility:       "n"
:Is choice item:   false
:Is defined:       true
:Is from env.:     false
:Is special:       false
:Prompts:

 *  "Local APIC Timer IRQ Priority" if LOAPIC_TIMER (value: "n")
:Default values:

 *  2 (value: "n")
 *   Condition: LOAPIC_TIMER (value: "n")
 *  2 (value: "n")
 *   Condition: (none)
:Selects:
 (no selects)
:Reverse (select-related) dependencies:
 (no reverse dependencies)
:Additional dependencies from enclosing menus and ifs:
 SOC_SERIES_QUARK_D2000 (value: "n")
:Locations:
 * ../drivers/timer/Kconfig:111
 * ../arch/x86/soc/intel_quark/quark_d2000/Kconfig.defconfig.series:51