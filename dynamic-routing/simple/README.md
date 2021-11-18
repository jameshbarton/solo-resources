# Simple Dynamic Routing

This simple example shows how a header value `x-gloo-tenant` can be used in the context of a single matching rule to route to multiple upstreams. 

There are two upstreams, `tenant-um-upstream` and `tenant-dois-upstream`, both deployed in the `default` namespace.
* `tenant-um-upstream` is a static upstream pointing at the [httpbin.org](http://httpbin.org) service.
* `tenant-dois-upstream` is a static upstream pointing at the [ip-api.com](https://ip-api.com/) service.

The virtual service constructs a header `tenant-upstream` from a Gloo Edge transformation based on the `x-gloo-tenant` header that is provided with the external request. The `tenant-upstream` header is then used to select the appropriate upstream, all without building separate matchers for each upstream.

## How to Test

0. You'll need a Kubernetes cluster and associated tools. We tested this with GKE but any type of cluster should work fine.
1. Apply the two upstreams. 
```
kubectl apply -f tenant-upstreams.yaml
```
2. Apply the virtual service.
```
kubectl apply -f vs-dynamic.yaml
```
3. Test routing to the first upstream, the [httpbin](http://httpbin.org) service.
```
% curl -H "x-gloo-tenant: um" $(glooctl proxy url)/get -i
HTTP/1.1 200 OK
date: Thu, 18 Nov 2021 18:56:17 GMT
content-type: application/json
content-length: 391
server: envoy
access-control-allow-origin: *
access-control-allow-credentials: true
x-envoy-upstream-service-time: 40

{
  "args": {},
  "headers": {
    "Accept": "*/*",
    "Host": "34.138.145.188",
    "Tenant-Upstream": "tenant-um-upstream_default",
    "User-Agent": "curl/7.64.1",
    "X-Amzn-Trace-Id": "Root=1-6196a1d1-665ed9be0ec86a0c0c84fda7",
    "X-Envoy-Expected-Rq-Timeout-Ms": "15000",
    "X-Gloo-Tenant": "um"
  },
  "origin": "35.243.206.124",
  "url": "http://34.138.145.188/get"
}
```
4. Test routing to the second upstream, the [ip-api](https://ip-api.com/) service.
```
% curl -H "x-gloo-tenant: dois" $(glooctl proxy url)/json | jq .
{
  "status": "success",
  "country": "United States",
  "countryCode": "US",
  "region": "SC",
  "regionName": "South Carolina",
  "city": "North Charleston",
  "zip": "",
  "lat": 32.8771,
  "lon": -80.013,
  "timezone": "America/New_York",
  "isp": "Google LLC",
  "org": "Google Cloud (us-east1)",
  "as": "AS15169 Google LLC",
  "query": "35.243.206.124"
}
```

## Further Reading

There is more extensive discussion in this [blog](https://www.solo.io/blog/dynamic-routing-with-gloo-edge/).