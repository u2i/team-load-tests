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
        { duration: '20s', target: 1000 },
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

  let liveview = new Liveview("https://load-tests.fly.dev/chat/" + Math.floor(Math.random() * 1000000), "wss://load-tests.fly.dev/live/websocket?_csrf_token=aDYRNgp9AC4Sdy8iNyofAS0WCzoiJC0Q-WvPeITbTFfHGuSNJyMukBYT&_track_static%5B0%5D=https%3A%2F%2Fload-tests.fly.dev%2Fassets%2Fapp-a5fe870326318b359c192ce86b220d13.css%3Fvsn%3Dd&_track_static%5B1%5D=https%3A%2F%2Fload-tests.fly.dev%2Fassets%2Fapp-5c4f8076fe90c587f9a5a6925fee64bf.js%3Fvsn%3Dd&_mounts=0&_live_referer=undefined&vsn=2.0.0");

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
