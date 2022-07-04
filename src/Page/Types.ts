export type WebState = { hello: string, n: number };
export type WebEvent = {
  increase: () => Promise<void>,
  makeZero: () => Promise<void>,
  testElectronAsync_on: () => Promise<void>,
  testElectronAsync_send: () => Promise<void>,
  testElectronSync: () => Promise<void>
};
