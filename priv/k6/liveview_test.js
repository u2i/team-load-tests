import Liveview from "./utilities/phoenix-liveview.js";
import { check, sleep } from "k6";

// See https://k6.io/docs/using-k6/options/#using-options for documentation on k6 options
export const options = {
  // vus: 10,
  // duration: '10s',
  // iterations: 100,
  scenarios: {
    contacts: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '20s', target: 100 },
        { duration: '10s', target: 0 },
      ],
      gracefulRampDown: '0s',
    },
  },
};

export default function () {
  // To set dynamic (e.g. environment-specific) configuration, pass it either as environment
  // variable when invoking k6 or by setting `:k6, env: [key: "value"]` in your `config.exs`,
  // and then access it from `__ENV`, e.g.: `const url = __ENV.url`

  let liveview = new Liveview("https://loadnewapp.fly.dev/chat/" + Math.floor(Math.random() * 1000000), "wss://loadnewapp.fly.dev/live/websocket?vsn=2.0.0");

  let res = liveview.connect(() => {
    liveview.send(
      "event",
      { type: "submit", event: "save", value: { message: { message: "test" }} },
      (_response) => {
        // liveview.leave();
      }
    );
    sleep(1);
    liveview.send(
      "event",
      { type: "submit", event: "save", value: { message: { message: "test 2" }} },
      (_response) => {
         // liveview.leave();
      }
    );
    sleep(1);
    liveview.leave();
  });
  check(res, { "status is 101": (r) => r && r.status === 101 });
}
