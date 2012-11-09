LIB	= Tg
CFLAGS	+= -I$(Cm) 
YSRCS	= PzHostDef.y PzScenario.y
SRCS	= \
	TgAgent.cc TgIF.cc TgAccept.cc TgServer.cc TgClient.cc TgFrame.cc \
	TcAgent.cc TcAccept.cc TcSocket.cc TcTCPSocket.cc TcUDPSocket.cc \
	TeAgent.cc TeIF.cc TeAccept.cc TeServer.cc TeClient.cc \
	TeCmd.cc TgAgntLg.cc	\
	$(YSRCS:.y=.cc) \
	TgHostDef.cc    \
	TgScenario.cc   \
	LxHostDef.cc    \
	LxScenario.cc   \
	LxLexer.cc      \
	TgInfo.cc       \
	TgReqElm.cc	\
	TgStatement.cc  \
	TgAgntCtrl.cc   \
	TgExecTimer.cc  \
	TgExecThread.cc \
	TgPostPrcs.cc   \
	TgError.cc		\
	TgDebug.cc		\
	TgSyncEvent.cc

.include "bsd.lib.mk"
