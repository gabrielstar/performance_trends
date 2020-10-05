import http from 'k6/http';
import { sleep } from 'k6';

export default function() {
  let localhost = 'host.docker.internal'
  http.get(`http://${localhost}:3000/url`);
  sleep(1);
}