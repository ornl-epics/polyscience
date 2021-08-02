#!../../bin/linux-x86_64/PolyScience
#
## You may have to change PolyScience to something else
## everywhere it appears in this file

< envPaths

cd "${TOP}"

epicsEnvSet("STREAM_PROTOCOL_PATH", "$(POLYSCIENCE)/protocol/")



## Register all support components
dbLoadDatabase "dbd/PolyScience.dbd"
PolyScience_registerRecordDeviceDriver pdbbase
drvAsynIPPortConfigure ("PolyScience1","10.112.63.122:4005",0,0,0)





#This prints low level commands and responses
asynSetTraceMask("PolyScience1",0,0x07)
asynSetTraceIOMask("PolyScience1",0,0x07)




## Load record instances
#dbLoadRecords("db/xxx.db","user=zmaHost")
dbLoadRecords(db/cg3-SE-PolyScience.db)



####################################################
# autosave

epicsEnvSet IOCNAME cg3-SE-PolyScience
epicsEnvSet SAVE_DIR /home/controls/var/$(IOCNAME)

save_restoreSet_Debug(0)

### status-PV prefix, so save_restore can find its status PV's.
save_restoreSet_status_prefix("CG3:SE:PolyScience:")

set_requestfile_path("$(SAVE_DIR)")
set_savefile_path("$(SAVE_DIR)")

save_restoreSet_NumSeqFiles(3)
save_restoreSet_SeqPeriodInSeconds(600)
set_pass1_restoreFile("$(IOCNAME).sav")

#####################################################



cd "${TOP}/iocBoot/${IOC}"
iocInit

#asynSetTraceMask("PolyScience1",0,0x07)
#asynSetTraceIOMask("PolyScience1",0,0x07)


# Create request file and start periodic 'save'
epicsThreadSleep(5)
makeAutosaveFileFromDbInfo("$(SAVE_DIR)/$(IOCNAME).req", "autosaveFields")
create_monitor_set("$(IOCNAME).req", 5)




#var mediatorVerbosity 7

#var mySubDebug 7

## Start any sequence programs
#seq sncxxx,"user=zmaHost"
