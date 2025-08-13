# Fiwix kernel coding standards

It's easier on everyone if all authors working on a shared code base are
consistent in the way they write their programs. Fiwix has the following
conventions in its code:

- Keep lines length to a maximum of 80 characters (some exceptions accepted).
- Use snake_case for identifiers except preprocessor macros.
- No space after the name of a function in a call (e.g., `printk("hello")`).
- Optional space after keywords `if`, `for`, `while`, `switch`.
- Space before braces, except in function declarations.
- Space between operands (e.g., `for(n = 0; n < 10; n++)`).
- Beginning-of-line indentation via tabs, not spaces.
- Preprocessor macros are always UPPERCASE.
- Pointer types have spaces: `(uint16_t *)`, not `(uint16_t*)`.
- The pointer qualifier `*` should be with the variable name rather than with
  the type.
- Comments in code use C89 style `/* ... */`.
- Multi-line comments start with a capital letter and end with a period. The
  opening and closing tags appear on separate lines:

```c
/*
 * Comment line 1
 * comment line 2
 */
```
