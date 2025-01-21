*&---------------------------------------------------------------------*
*& Include          ZLCL_CLASS
*&---------------------------------------------------------------------*

*Classes para botões na ALV
*-----------------------------------
* class lcl_handle_events
*

*Cenas do ALV

CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.

    METHODS: on_click FOR EVENT added_function OF cl_salv_events.

  PRIVATE SECTION.
    DATA: gr_alv TYPE REF TO cl_salv_table.
ENDCLASS.

CLASS lcl_handle_events  IMPLEMENTATION.
  METHOD on_click.
    CASE sy-ucomm.  "At user command
      WHEN 'LIBERAR'.

        PERFORM get_selected_rows.
        PERFORM release_order.

        REFRESH lt_temp_data.
        PERFORM get_data.

        lo_alv->refresh(
          EXPORTING
            refresh_mode = if_salv_c_refresh=>soft " ALV: Data Element for Constants
        ).
      WHEN 'EDIT'.

        PERFORM get_selected_rows.
        IF lines( lt_temp_data ) GT 1.
          MESSAGE 'Please select only one line at a time.' TYPE 'I'.
          RETURN.
        ELSE.
          READ TABLE lt_temp_data INTO DATA(ls_selected) INDEX 1.
        ENDIF.
        IF sy-subrc = 0.
          CALL SCREEN 0100 STARTING AT 10 10.
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
          MESSAGE 'Please select a line' TYPE 'E'.
          RETURN.
        ENDIF.

        DATA: lv_first_ebeln TYPE ekko-ebeln,
              lv_diff_ebeln  TYPE abap_bool VALUE abap_false. "https://desenvolvimentoaberto.org/2014/02/19/tipo-booleano-abap_bool-abap/

        READ TABLE lt_temp_data INTO ls_temp_data INDEX 1.
        IF sy-subrc = 0.
          lv_first_ebeln = ls_temp_data-ebeln.
        ENDIF.

        LOOP AT lt_temp_data INTO ls_temp_data-ebeln.
          IF ls_temp_data-ebeln NE lv_first_ebeln.
            lv_diff_ebeln = abap_true.
            EXIT.
          ENDIF.
        ENDLOOP.

        IF lv_diff_ebeln = abap_false AND lines( lt_temp_data ) > 1.
          MESSAGE 'Só pode enviar um email por ordem de compra.' TYPE 'E'.
          else.
            call SCREEN 0200.
        ENDIF.

      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.                    "on_click
ENDCLASS.

DATA: event_handler   TYPE REF TO lcl_handle_events.                  "lcl_handle_events IMPLEMENTATION

*        Para enviar e-mail ao comprador, o utilizador apenas pode selecionar mais do que uma linha, desde que:
*•  As linhas selecionadas sejam referentes ao mesmo pedido de compra
*Caso para as linhas selecionadas exista mais do que um pedido de compra, deverá ser emitida a seguinte mensagem:
*•  “Apenas pode enviar e-mail referente a um pedido de compra”
*
*Caso apenas tenha sido selecionado um e-mail:
*         • deverá ser disponibilizado um ecrã para que o utilizador preencha o texto a escrever.
*         •	Um botão de cancelar e outro de enviar
