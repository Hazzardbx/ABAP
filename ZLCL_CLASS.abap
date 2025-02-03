*&---------------------------------------------------------------------*
*& Include          ZLCL_CLASS
*&---------------------------------------------------------------------*

*Classes para botões na ALV
*-----------------------------------
* class lcl_handle_events
*Clase para manipular eventos

CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.

    METHODS: on_click FOR EVENT added_function OF cl_salv_events.

  PRIVATE SECTION.
    DATA: gr_alv TYPE REF TO cl_salv_table.
ENDCLASS.

CLASS lcl_handle_events  IMPLEMENTATION.
  METHOD on_click.
    CASE sy-ucomm.
      WHEN 'LIBERAR'.

        PERFORM get_selected_rows.
        PERFORM release_order.

        REFRESH lt_temp_data.
        PERFORM get_data.

        lo_alv->refresh(
          EXPORTING
            refresh_mode = if_salv_c_refresh=>soft " Refresh da ALV: Data Element for Constants
        ).

      WHEN 'EDIT'.

        PERFORM get_selected_rows.
        IF lines( lt_temp_data ) GT 1.
          MESSAGE w016(zcl_ckf_msg).
          RETURN.
        ELSE.
          READ TABLE lt_temp_data INTO DATA(ls_selected) INDEX 1.
        ENDIF.
        IF sy-subrc = 0.
          CALL SCREEN 0100 STARTING AT 50 50.
        ENDIF.

      WHEN 'REFRESH'.

        PERFORM get_data.

        lo_alv->refresh(
          EXPORTING
*              s_stable     =                         " ALV Control: Refresh Stability
            refresh_mode = if_salv_c_refresh=>full " ALV: Data Element for Constants
        ).

      WHEN 'DELETE'.

        PERFORM delete_order.
        lo_alv->refresh(
EXPORTING
*              s_stable     =                         " ALV Control: Refresh Stability
 refresh_mode = if_salv_c_refresh=>full " ALV: Data Element for Constants
).

      WHEN 'MAIL'.
        PERFORM get_selected_rows.

        IF lt_selected_rows IS INITIAL.
          MESSAGE s017(zcl_ckf_msg).
          RETURN.
        ENDIF.



        SORT lt_temp_data BY ebeln ASCENDING.

        IF lines( lt_temp_data ) > 1.
          READ TABLE lt_temp_data INTO ls_temp_data INDEX 1.
          old_ebeln = ls_temp_data-ebeln.
          LOOP AT lt_temp_data INTO ls_temp_data.
            IF old_ebeln = ls_temp_data-ebeln.
              APPEND ls_temp_data TO lt_temp_data2.
            ELSE.
              MESSAGE w018(zcl_ckf_msg). "um registo de cada x
              RETURN.

            ENDIF.
            old_ebeln = ls_temp_data-ebeln.

          ENDLOOP.
        ELSE.
          READ TABLE lt_temp_data INTO ls_temp_data INDEX 1.
          old_ebeln = ls_temp_data-ebeln.
          LOOP AT lt_temp_data INTO ls_temp_data.
            IF old_ebeln = ls_temp_data-ebeln.
              APPEND ls_temp_data TO lt_temp_data2. "adicionar a linha a tabela 2
            ENDIF.
          ENDLOOP.
        ENDIF.

        IF lt_temp_data2 IS NOT INITIAL.
          CALL SCREEN 0200.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.                    "on_click
ENDCLASS.

DATA: event_handler   TYPE REF TO lcl_handle_events.                  "lcl_handle_events IMPLEMENTATION
