#############################################################################
#			INTERPEAK MAKEFILE
#
#     Document no: @(#) $Name: VXWORKS_ITER18A_FRZ10 $ $RCSfile: ipcom_arch.mk,v $ $Revision: 1.1 $
#     $Source: /home/interpeak/CVSRoot/ipcom/arch/gmake/ipcom_arch.mk,v $
#     $Author: lob $
#     $State: Exp $ $Locker:  $
#
#     INTERPEAK_COPYRIGHT_STRING
#
#############################################################################

#############################################################################
# DESCRIPTION
#############################################################################
# IPCOM common arch GNU makefile template.

-include $(IPCOM_ROOT)/arch/$(IPARCH)/gmake/ipcom_$(IPARCH).mk


#############################################################################
# IPDEFINE
#############################################################################


#############################################################################
# OBJECTS
#############################################################################
# IPCOM arch object:

ifneq ($(IPCOM_ARCH),yes)
IPLIBOBJECTS += ipcom_arch.o
endif


#############################################################################
# VPATH
#############################################################################

IPSRCDIRS += $(IPCOM_ROOT)/arch/src


#############################################################################
# END OF IPCOM_ARCH.MK
#############################################################################
