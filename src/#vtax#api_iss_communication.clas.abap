CLASS /vtax/api_iss_communication DEFINITION
  PUBLIC
  INHERITING FROM /s4tax/api_signed_service
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES /vtax/iapi_iss_communication.

    CLASS-METHODS:
      get_instance IMPORTING api_auth      TYPE REF TO /s4tax/iapi_auth OPTIONAL
                   RETURNING VALUE(result) TYPE REF TO /vtax/iapi_iss_communication
                   RAISING   /s4tax/cx_http /s4tax/cx_auth.

  PROTECTED SECTION.

    CLASS-DATA:
          instance TYPE REF TO /vtax/iapi_iss_communication.

  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF api_paths,
        send_nfts_ba2927408 TYPE string VALUE 'nftmessengerservice:3000/api/sign',
        query_xml           TYPE string VALUE '/reinfmonitorservice/api/communication/response/:solicitation_id/:option',
      END OF api_paths.

    METHODS:
      config_json_response
        IMPORTING json_config TYPE REF TO /s4tax/json_element_config.

ENDCLASS.



CLASS /vtax/api_iss_communication IMPLEMENTATION.
  METHOD /vtax/iapi_iss_communication~sign_nfts_ba2927408.

    DATA: config_generator TYPE REF TO /s4tax/json_config_generator,
          json_config      TYPE REF TO /s4tax/json_element_config,
          request_dto      TYPE REF TO /s4tax/request.

    request_dto = create_custom_request_dto( context  = /s4tax/constants=>context-dfe ).

    create_request_obj( EXPORTING session      = me->session
                                  http_path    = api_paths-send_nfts_ba2927408
                                  http_method  = /s4tax/http_operation=>http_methods-post
                                  input        = input
                                  request_dto  = request_dto
                         CHANGING  output      = result
                                   request     = last_request ).

    CREATE OBJECT config_generator EXPORTING name_to_camel = abap_true.
    json_config = config_generator->generate_data_type_config( input ).
*       json_config->change_ext_name_by_path( abap_name = 'INFO_CONTRI.INCLUSAO.INFO_CADASTRO.IND_SIT_PJ' ext_name  = 'indSitPJ' ).
*       json_config->change_ext_name_by_path( abap_name = 'INFO_CONTRI.ALTERACAO.INFO_CADASTRO.IND_SIT_PJ' ext_name  = 'indSitPJ' ).
    last_request->add_prop( EXPORTING name = /s4tax/http_request=>commom_props_name-request_element_config
                                      obj  = json_config ).

    CREATE OBJECT config_generator EXPORTING name_to_camel = abap_true.
    json_config = config_generator->generate_data_type_config( result ).
    config_json_response( json_config ).
    last_request->add_prop( EXPORTING name = /s4tax/http_request=>commom_props_name-response_element_config
                                          obj  = json_config ).

    last_request->send( ).

  ENDMETHOD.

  METHOD config_json_response.
    json_config->change_ext_name_by_path( abap_name = 'SOLICITATION_ID' ext_name = 'solicitation_id' ).
  ENDMETHOD.

  METHOD get_instance.

    DATA: session           TYPE REF TO /s4tax/session,
          api_authorization TYPE REF TO /s4tax/iapi_auth.

    IF instance IS BOUND.
      result = instance.
      RETURN.
    ENDIF.

    api_authorization = api_auth.
    IF api_authorization IS NOT BOUND.
      api_authorization      = /s4tax/api_auth=>default_instance( ).
    ENDIF.

    session       = api_auth->login( /s4tax/defaults=>customer_profile_name ).
    CREATE OBJECT instance TYPE /vtax/api_iss_communication EXPORTING session = session.
    result = instance.

  ENDMETHOD.

ENDCLASS.
