; extends

((call_expression
  function: (selector_expression
    field: (field_identifier) @_method)
  arguments: (argument_list
    (_)
    .
      (raw_string_literal
      (raw_string_literal_content) @injection.content)))
  (#any-of? @_method "ExecContext" "QueryContext" "GetContext" "SelectContext")
  (#set! injection.language "sql"))

((call_expression
  function: (selector_expression
    field: (field_identifier) @_method)
  arguments: (argument_list
    (_)
    (_)
    .
    (raw_string_literal
      (raw_string_literal_content) @injection.content)))
  (#any-of? @_method "GetContext" "SelectContext")
  (#set! injection.language "sql"))

((const_spec
  name: (identifier) @_name
  value: (expression_list
    (raw_string_literal
      (raw_string_literal_content) @injection.content)))
  (#match? @_name "^(query|sql|stmt)$")
  (#set! injection.language "sql"))

((var_spec
  name: (identifier) @_name
  value: (expression_list
    (raw_string_literal
      (raw_string_literal_content) @injection.content)))
  (#match? @_name "^(query|sql|stmt)$")
  (#set! injection.language "sql"))

((short_var_declaration
  left: (expression_list
    (identifier) @_name)
  right: (expression_list
    (raw_string_literal
      (raw_string_literal_content) @injection.content)))
  (#match? @_name "^(query|sql|stmt)$")
  (#set! injection.language "sql"))
