TOP=../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE

USR_DBFLAGS += -I$(TOP)/mrmShared/Db

DB += mrmevrout.db
DB += mrmevrdc.template
DB += mrmevrbufrx.db
DB += sequencedemo.db

DB += evr-pmc-230.db
DB += evr-cpci-230.db
DB += evr-cpci-300.db
DB += evr-vmerf-230.db
DB += evr-tg-300.db
DB += evr-mtca-300.db
DB += evr-pcie-300dc.db

ifneq ($(DEVIOCSTATS),)
DB_INSTALLS += $(DEVIOCSTATS)/db/iocAdminRTEMS.db
DB_INSTALLS += $(DEVIOCSTATS)/db/iocAdminSoft.db
endif

USR_DBFLAGS += -I . -I .. -I $(INSTALL_LOCATION)/db

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

