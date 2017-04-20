// Automatically generated by MockGen. DO NOT EDIT!
// Source: github.com/cloudfoundry/bosh-init/deployment/vm (interfaces: ManagerFactory)

package mocks

import (
	agentclient "github.com/cloudfoundry/bosh-agent/agentclient"
	cloud "github.com/cloudfoundry/bosh-init/cloud"
	vm "github.com/cloudfoundry/bosh-init/deployment/vm"
	gomock "github.com/golang/mock/gomock"
)

// Mock of ManagerFactory interface
type MockManagerFactory struct {
	ctrl     *gomock.Controller
	recorder *_MockManagerFactoryRecorder
}

// Recorder for MockManagerFactory (not exported)
type _MockManagerFactoryRecorder struct {
	mock *MockManagerFactory
}

func NewMockManagerFactory(ctrl *gomock.Controller) *MockManagerFactory {
	mock := &MockManagerFactory{ctrl: ctrl}
	mock.recorder = &_MockManagerFactoryRecorder{mock}
	return mock
}

func (_m *MockManagerFactory) EXPECT() *_MockManagerFactoryRecorder {
	return _m.recorder
}

func (_m *MockManagerFactory) NewManager(_param0 cloud.Cloud, _param1 agentclient.AgentClient) vm.Manager {
	ret := _m.ctrl.Call(_m, "NewManager", _param0, _param1)
	ret0, _ := ret[0].(vm.Manager)
	return ret0
}

func (_mr *_MockManagerFactoryRecorder) NewManager(arg0, arg1 interface{}) *gomock.Call {
	return _mr.mock.ctrl.RecordCall(_mr.mock, "NewManager", arg0, arg1)
}
