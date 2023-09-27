# Which Swift to use.
SWIFT:=swift
# Where products will be built; this is the SPM default.
SWIFT_BUILD_PATH:=./.build
SWIFT_BUILD_CONFIGURATION=debug
SWIFT_FLAGS=--build-path=${SWIFT_BUILD_PATH} --configuration=${SWIFT_BUILD_CONFIGURATION} --enable-test-discovery
# Force release configuration (for plugins)
SWIFT_FLAGS_RELEASE=$(patsubst --configuration=%,--configuration=release,$(SWIFT_FLAGS))

# protoc plugins.
PROTOC_GEN_SWIFT=${SWIFT_BUILD_PATH}/release/protoc-gen-swift
PROTOC_GEN_GRPC_SWIFT=${SWIFT_BUILD_PATH}/release/protoc-gen-grpc-swift

SWIFT_BUILD:=${SWIFT} build ${SWIFT_FLAGS}
SWIFT_BUILD_RELEASE:=${SWIFT} build ${SWIFT_FLAGS_RELEASE}
SWIFT_TEST:=${SWIFT} test ${SWIFT_FLAGS}
SWIFT_PACKAGE:=${SWIFT} package ${SWIFT_FLAGS}

### Package and plugin build targets ###########################################

all:
	${SWIFT_BUILD}

Package.resolved:
	${SWIFT_PACKAGE} resolve

.PHONY:
plugins: ${PROTOC_GEN_SWIFT} ${PROTOC_GEN_GRPC_SWIFT}
	cp $^ .

${PROTOC_GEN_SWIFT}: Package.resolved
	${SWIFT_BUILD_RELEASE} --product protoc-gen-swift

${PROTOC_GEN_GRPC_SWIFT}: Sources/protoc-gen-grpc-swift/*.swift
	${SWIFT_BUILD_RELEASE} --product protoc-gen-grpc-swift

interop-test-runner:
	${SWIFT_BUILD} --product GRPCInteroperabilityTests

interop-backoff-test-runner:
	${SWIFT_BUILD} --product GRPCConnectionBackoffInteropTest

### Protobuf Generation ########################################################

%.pb.swift: %.proto ${PROTOC_GEN_SWIFT}
	protoc $< \
		--proto_path=$(dir $<) \
		--plugin=${PROTOC_GEN_SWIFT} \
		--swift_opt=Visibility=Public \
		--swift_out=$(dir $<)

%.grpc.swift: %.proto ${PROTOC_GEN_GRPC_SWIFT}
	protoc $< \
		--proto_path=$(dir $<) \
		--plugin=${PROTOC_GEN_GRPC_SWIFT} \
		--grpc-swift_opt=Visibility=Public \
		--grpc-swift_out=$(dir $<)

.PHONY:
generate-tictactoe: ${TIC_TAC_TOE_PB} ${TIC_TAC_TOE_GRPC}

TIC_TAC_TOE_PROTO=Multiplayer_3D_TicTacToe/Source/gRPC/Domain/Model/tic_tac_toe.proto
TIC_TAC_TOE_PB=$(TIC_TAC_TOE_PROTO:.proto=.pb.swift)
TIC_TAC_TOE_GRPC=$(TIC_TAC_TOE_PROTO:.proto=.grpc.swift)

