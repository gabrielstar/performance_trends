import http from 'k6/http';
import { sleep } from 'k6';

export function setup() {
  let res = http.get("https://httpbin.org/get");
  return { data: res.json() };
}

export function teardown(data) {
  console.log(JSON.stringify(data));
}

export default function() {
  http.get('http://test.k6.io');
  sleep(1);
}