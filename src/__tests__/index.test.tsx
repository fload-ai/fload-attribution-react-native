import { afterEach, beforeEach, describe, expect, it, jest } from '@jest/globals';
import packageJson from '../../package.json';

type Native = {
  configure: jest.Mock;
  setUserId: jest.Mock;
  getInstallReference: jest.Mock;
};

function loadModule(native: Native | null) {
  let api!: typeof import('../index');
  jest.isolateModules(() => {
    jest.doMock('../NativeFloadAttribution', () => ({ __esModule: true, default: native }));
    api = require('../index');
  });
  return api;
}

function load(native: Native | null) {
  return loadModule(native).FloadAttribution;
}

function fakeNative(): Native {
  return {
    configure: jest.fn(),
    setUserId: jest.fn(),
    getInstallReference: jest.fn(() => Promise.resolve('7d1e2f60-reference')),
  };
}

let warn: jest.SpiedFunction<typeof console.warn>;

beforeEach(() => {
  warn = jest.spyOn(console, 'warn').mockImplementation(() => {});
});

afterEach(() => {
  warn.mockRestore();
  delete (globalThis as { expo?: unknown }).expo;
});

describe('with the native module', () => {
  it('configure passes the key, no endpoint and the warning level by default', () => {
    const native = fakeNative();
    load(native).configure('fload_pk_test');
    expect(native.configure).toHaveBeenCalledWith(
      'fload_pk_test',
      null,
      'warning',
      'react-native',
      packageJson.version
    );
  });

  it('configure names this wrapper and its package.json version (FLO-3957)', () => {
    const native = fakeNative();
    load(native).configure('fload_pk_test');
    const [, , , wrapperName, wrapperVersion] = native.configure.mock.calls[0] ?? [];
    expect(wrapperName).toBe('react-native');
    expect(wrapperVersion).toBe(packageJson.version);
  });

  it('VERSION is the package.json version', () => {
    expect(loadModule(fakeNative()).VERSION).toBe(packageJson.version);
  });

  it('configure passes the endpoint and log level it is given', () => {
    const native = fakeNative();
    load(native).configure('fload_pk_test', { endpoint: 'http://localhost:3999', logLevel: 'debug' });
    expect(native.configure).toHaveBeenCalledWith(
      'fload_pk_test',
      'http://localhost:3999',
      'debug',
      'react-native',
      packageJson.version
    );
  });

  it('configure refuses an unknown log level before reaching native code', () => {
    const native = fakeNative();
    const sdk = load(native);
    expect(() => sdk.configure('fload_pk_test', { logLevel: 'verbose' as never })).toThrow(TypeError);
    expect(native.configure).not.toHaveBeenCalled();
  });

  it('setUserId passes the id through', () => {
    const native = fakeNative();
    load(native).setUserId('$RCAnonymousID:abc');
    expect(native.setUserId).toHaveBeenCalledWith('$RCAnonymousID:abc');
  });

  it('getInstallReference resolves what the native SDK holds', async () => {
    await expect(load(fakeNative()).getInstallReference()).resolves.toBe('7d1e2f60-reference');
  });

  it('never warns', () => {
    const sdk = load(fakeNative());
    sdk.configure('fload_pk_test');
    sdk.setUserId('user_1');
    expect(warn).not.toHaveBeenCalled();
  });
});

describe('without the native module', () => {
  it('does nothing and warns once that the app needs a rebuild', async () => {
    const sdk = load(null);
    sdk.configure('fload_pk_test');
    sdk.setUserId('user_1');
    await expect(sdk.getInstallReference()).resolves.toBeNull();
    expect(warn).toHaveBeenCalledTimes(1);
    expect(warn.mock.calls[0]?.[0]).toMatch(/not linked/);
  });

  it('in Expo Go, warns once that Expo Go cannot load it', () => {
    (globalThis as { expo?: unknown }).expo = { modules: { ExpoGo: {} } };
    const sdk = load(null);
    sdk.configure('fload_pk_test');
    sdk.configure('fload_pk_test');
    expect(warn).toHaveBeenCalledTimes(1);
    expect(warn.mock.calls[0]?.[0]).toMatch(/Expo Go cannot load native code/);
  });
});
