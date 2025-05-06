# Signal Release Notes

## Version: 0.0.0  
**Date:** 2025-05-06  
**Status:** Experimental Preview

---

### Overview

This is the **initial public release** of **Signal**, a low-level ARM64-based control language designed to support deterministic computation and memory operations at runtime.  
Signal serves as the execution-layer foundation of [TreeOS].

---

### Included in this Release

- `loop_pipeline.s`:  
  A full implementation of a vectorized loop (`a → b → c`) with success/failure feedback and memory logging.

- English documentation:
  - Execution logic of the pipeline model
  - Register-level explanation
  - Planned error recording (`D`, `E` arrays)

- Licensing files:
  - `LICENSE` (MIT-style)
  - `COMMERCIAL.md` for commercial terms

---

### Limitations

- Only one runtime example (`loop_pipeline`) is included
- No assembler toolchain scripts or automated build
- No error replay or retry logic implemented yet
- Bare-metal only; no OS abstraction or IO layer

---

### Roadmap

Planned for future versions:

- `grow()` / `live()` / `fall()` instruction primitives
- SapClarify integration layer
- Signal 0.1.x toolchain prototype
- GitHub Pages documentation
- Formal runtime error bus and stack system

---

**Contact**:  
For feedback, licensing, or collaboration requests, email:  
**shizuka@treeos.art**
