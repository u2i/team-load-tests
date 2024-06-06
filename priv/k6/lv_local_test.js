import Liveview from "./utilities/phoenix-liveview.js";
import { check } from "k6";


// See https://k6.io/docs/using-k6/options/#using-options for documentation on k6 options
export const options = {
  vus: 10,
  duration: '10s',
};

export default function () {
  // To set dynamic (e.g. environment-specific) configuration, pass it either as environment
  // variable when invoking k6 or by setting `:k6, env: [key: "value"]` in your `config.exs`,
  // and then access it from `__ENV`, e.g.: `const url = __ENV.url`

  let liveview = new Liveview("http://localhost:4000/chat/" + Math.floor(Math.random() * 1000000), "ws://localhost:4000/live/websocket?vsn=2.0.0");

  let res = liveview.connect(() => {
    liveview.send(
      "event",
      { type: "submit", event: "save", value: { message: { message: "test" }} },
      (_response) => {
        liveview.leave();
      }
    );
  });
  check(res, { "status is 101": (r) => r && r.status === 101 });
}
