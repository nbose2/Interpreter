# What the given code does (at least from how I (Shuyang) understand it)
For now, I'm naming it as ReadMe.md as github renders ReadMe directly on the front page of the repo. </br>
I know this may seems like a overkill, but I just want it to be clear to at least myself

# Parser
## 1. User-Defined Types

### `symbol_productions`
  * A tuple contains two elements:
     1. a `string` representing the name of the nonterminal
     2. a `list` of all productions of that nonterminal (a `list` also)
  * Example:
    - For __TT -> ao T TT | epsilon__, the `symbol_productions` would be:
      - `("TT", [["ao"; "T"; "TT"]; []])`


### `grammar`
  * A `list` of `symbol_productions`
  * (string \* string list list) list
  * Consists of `symbol_productions` for all of the nonterminals

### `parse_table`
  * (string \* (string list \* string list) list) list
  * A `list` of tuples containing two things:
     1. A `string` representing the name of the nonterminal
     2. Another `list` of tuples containing:
      1. A `list` of `string` representing the PREDICT set of the nonterminal
      2. A `list` of `string` representing the corresponding rhs of the production

  ```
    A parse_table example

    [
      ("P", [(["id";"read";"write";"$$"],["SL";"$$"])]);
      ("SL", [(["id";"read";"write"], ["S";"SL"]);
              ("$$",[])]);
      ("S", [(["id"],["id";":=";"E"]);
             (["read"],["read";"id"]);
             (["write"],["write";"E"])]);
      ...
    ]
  ```

### `right_context`
  * (string \* string list) list
  * A `list` of tuples containing:
    1. A `string` representing a nonterminal (context)
    2. A `list` of `string` representing the FOLLOW set
  * type used in `get_right_context` function as a return type, more details are explained in the description of `get_right_context`

### `symbol_knowledge`
  * A 4-element tuple:
    1. nonterminal : `string`
    2. nullable? : `bool`
    3. FIRST set : `string list`
    4. FOLLOW set : `string list`
  * Example:
    * for nonterminal __P__, the `symbol_knowledge` would be:
      ```
      ("P", false, ["$$"; "id"; "read"; "write"], [])
      ```
    * for nonterminal __SL__, the `symbol_knowledge` would be:
      ```
      ("SL", true, ["id"; "read"; "write"], ["$$"])
      ```

### `knowledge`
  * A list of `symbol_knowledge`

### `ps_item`
  * either a `int` or a `string`
    - PS_end : `int`
    - PS_sym : `string`
