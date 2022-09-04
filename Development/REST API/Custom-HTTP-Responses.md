The API server has custom response codes for things like app start and infra not deployed.   
Below is a table of these non-standard codes for quick reference.   
They are also defined in the [OpenAPI specification document](./OpenAPI-Spec).

---

| HTTP response code | Description |
| :------------------| :-----------|
| 520 | App is starting still. Feature is not available. Please try again later. |
| 525 | Not deployed. Please deploy the infra before using this feature. |