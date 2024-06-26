import http from "k6/http";
import { check, sleep } from "k6";

// See https://k6.io/docs/using-k6/options/#using-options for documentation on k6 options
export const options = {
  vus: 10,
  duration: '30s',
  thresholds: { // See https://k6.io/docs/using-k6/thresholds/
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<200'],
  }
};

export default function () {
  // To set dynamic (e.g. environment-specific) configuration, pass it either as environment
  // variable when invoking k6 or by setting `:k6, env: [key: "value"]` in your `config.exs`,
  // and then access it from `__ENV`, e.g.: `const url = __ENV.url`

  let baseUrl = "http://localhost:4000/chat/1";

  // See https://k6.io/docs/using-k6/protocols/http-2/ for documentation on k6 and HTTP
  let res = http.get(baseUrl);
  check(res, { success: (r) => r.status === 200 });
  sleep(0.3);
}
