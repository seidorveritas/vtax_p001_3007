INTERFACE /vtax/iapi_iss_communication
  PUBLIC .

  METHODS sign_nfts_ba2927408
    IMPORTING input         TYPE /vtax/s489
    RETURNING VALUE(result) TYPE /vtax/s490
    RAISING   /s4tax/cx_http.

ENDINTERFACE.
