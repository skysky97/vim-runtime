" vim syntax file
" language: log
" author: Yunting Li

" if exists("b:log_style")
"   finish
" endif


let b:log_style = "log4"

syntax match logBegin2 "^\S\+\s\+\S\+"
" First 2 columns 
syntax keyword logError ERROR containedin=logBegin2 contained
syntax keyword logWarn WARN containedin=logBegin2 contained
syntax keyword logInfo INFO containedin=logBegin2 contained
syntax keyword logDebug DEBUG containedin=logBegin2 contained
syntax region logString start=/\%(L\|U\|u8\)\="/ skip=/\\\\\|\\"/ end=/"/ contains=logDdsBuiltin

" Time style: 2022-02-28T10:14:01.983543485+00:00 
syntax match logTime "^\d\{4\}-\d\{2\}-\d\{2\}T\d\{2\}:\d\{2\}:\d\{2\}\.\d\{9\}+\d\{2\}:\d\{2\}" 
" Time style: 12.988944
syntax match logTime "^\d\+\.\d\{6,9\}"

" Cyclonedds
syntax match logGuid "\w\+:\w\+:\w\+:\w\+"
syntax keyword logDdsMsg HEARTBEAT ACKNACK NACKFRAG
syntax keyword logDdsMsg SPDP SEDP
syntax keyword logDdsMsg HDR
syntax keyword logDdsMsg DATA DATAFRAG
syntax keyword logDdsMsg INFOTS INFODST INFOSRC 
syntax keyword logDdsBuiltin DCPSParticipant ParticipantBuiltinTopicData
syntax keyword logDdsBuiltin DCPSPublication PublicationBuiltinTopicData
syntax keyword logDdsBuiltin DCPSSubscription SubscriptionBuiltinTopicData
syntax keyword logDdsBuiltin DCPSParticipantMessage ParticipantMessageData
syntax keyword logDdsBuiltin DCPSTopic TopicBuiltinTopicData
syntax keyword logDdsEntity READER WRITER PARTICIPANT

syntax match logDdsIp "\d\{1,3\}\.\d\{1,3\}\.\d\{1,3\}\.\d\{1,3\}"
syntax match logDdsLocator  "\d\{1,3\}\.\d\{1,3\}\.\d\{1,3\}\.\d\{1,3\}:\d\+" contains=logDdsIp

syntax keyword logDdsQos topic_name type_name group_data durability
syntax keyword logDdsQos user_data topic_data durability_service deadline
syntax keyword logDdsQos latency_budget liveliness reliability lifespan
syntax keyword logDdsQos destination_order history resource_limits ownership
syntax keyword logDdsQos ownership_strength presentation partition
syntax keyword logDdsQos transport_priority adlink_writer_data_lifecycle

" Highlight
hi link logTime Identifier
hi link logError Error
hi link logWarn Type
hi link logInfo Statement
hi link logDebug Statement

hi link logGuid Comment
hi link logDdsMsg Type
hi link logDdsEntity Type
hi link logDdsLocator Constant 
hi link logDdsIp Constant
hi link logDdsBuiltin PreProc
hi link logDdsQos UnderLined
hi link logString Constant
