
// k6 run --vus 10 --duration 30s load-test.js  ( Sample cmd to run 10 virtual users simultanously)
import http from 'k6/http';

export default function() {
    http.get('http://a93af9971dd4c4008b7f1c384cd9f49e-846034548.us-west-1.elb.amazonaws.com/cpu');
}
