export type State = { hello: string, n: number };
export type Event = {
  increase: () => Promise<void>,
  makeZero: () => Promise<void>,
  testElectronAsync_on: () => Promise<void>,
  testElectronAsync_send: () => Promise<void>,
  testElectronSync: () => Promise<void>
};
