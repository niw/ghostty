#ifndef MACH_VM_COMPAT_H
#define MACH_VM_COMPAT_H

#include <mach/mach_types.h>

// Define missing mach_vm_offset_list_t for newer macOS SDKs
#ifndef MACH_VM_OFFSET_LIST_T_DEFINED
#define MACH_VM_OFFSET_LIST_T_DEFINED

typedef mach_vm_offset_t *mach_vm_offset_list_t;

#endif // MACH_VM_OFFSET_LIST_T_DEFINED

#endif // MACH_VM_COMPAT_H
