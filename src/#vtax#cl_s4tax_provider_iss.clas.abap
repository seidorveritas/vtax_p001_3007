CLASS /vtax/cl_s4tax_provider_iss DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor.

    METHODS sign_nfts_ba2927408
      IMPORTING iv_bukrs        TYPE j_1bbranch-bukrs
                iv_branch       TYPE j_1bbranch-branch
                iv_xml          TYPE string
      RETURNING VALUE(r_result) TYPE string.

  PROTECTED SECTION.

    DATA: o_api_iss  TYPE REF TO /vtax/iapi_iss_communication.
    DATA v_branchid         TYPE /s4tax/e_branch_id.

  PRIVATE SECTION.
ENDCLASS.



CLASS /vtax/cl_s4tax_provider_iss IMPLEMENTATION.

  METHOD constructor.
    DATA: lo_api_auth TYPE REF TO /s4tax/iapi_auth,
          lo_session  TYPE REF TO /s4tax/session.

    lo_api_auth     = /s4tax/api_auth=>default_instance( ).
    lo_session      = lo_api_auth->login( /s4tax/defaults=>customer_profile_name ).

    me->o_api_iss = NEW /vtax/api_iss_communication( lo_session ).

  ENDMETHOD.

  METHOD sign_nfts_ba2927408.

    DATA: lo_dao        TYPE REF TO /s4tax/idao,
          lo_dao_branch TYPE REF TO /s4tax/idao_branch_config,
          lo_branch_cfg TYPE REF TO /s4tax/branch_config.

    DATA: lw_input  TYPE /vtax/s489,
          lw_output TYPE /vtax/s490.

    IF lo_dao IS  NOT BOUND.
      CREATE OBJECT lo_dao TYPE /s4tax/dao.
    ENDIF.

    lo_dao_branch = lo_dao->branch_config( ).

    lo_branch_cfg = lo_dao_branch->get(
                      company_code = iv_bukrs
                      branch_code  = iv_branch
                    ).

    IF lo_branch_cfg IS BOUND.
      me->v_branchid = lo_branch_cfg->get_branch_id( ).
    ENDIF.

    lw_input-branch_id = v_branchid.
    lw_input-data = iv_xml.

    lw_output = me->o_api_iss->sign_nfts_ba2927408( lw_input ).

  ENDMETHOD.

ENDCLASS.
