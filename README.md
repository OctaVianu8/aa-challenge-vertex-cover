# AA Challenge - Vertex Cover

Proiect pentru problema **Minimum Vertex Cover** - comparatie intre algoritmi exacti si euristici greedy.

**Autori:** Stanescu Matei-Octavian, Nitu Eriko-Laurentiu, Burca Paul (Grupa 322CA)

---

## Continutul Arhivei

- `src/` — sursele C++ (brute-force, euristici greedy, generatoare de teste)
- `scripts/` — scripturi pentru generare teste, rulare si benchmark
- `tests/` — input-uri, referinte si output-uri (generate automat)
- `report.tex` — documentatia completa
- `makefile` — build si pipeline

---

## Algoritmi Implementati

| Algoritm | Complexitate | Acuratete |
|----------|--------------|-----------|
| **brute-force** | O(2ⁿ · \|E\|) | 100% (optim) |
| **greedy-highest-order** | O(\|V\| · \|E\|) | 46.4% perfect, 94.1% avg |
| **greedy-remove-edges** | O(\|V\| · \|E\|) | 84.4% perfect, 98.6% avg |

---

## Cum se Evalueaza Solutiile

### 1. Compilare

```bash
make all
```

Compileaza toate sursele si plaseaza executabilele in `bin/`.

### 2. Pipeline Complet (Recomandat)

```bash
make pipeline COUNT=10
```

Aceasta executa automat:
1. **Generare teste** - 5 clase de grafuri (random 10%/30%/67%, bipartite, cycle-with-cords)
2. **Calculare referinte** - Ruleaza brute-force pentru solutii optime
3. **Rulare euristici** - Executa ambii algoritmi greedy pe toate testele
4. **Afisare rezultate** - Compara output-urile cu referintele

### 3. Benchmark Performanta

```bash
scripts/benchmark.sh
python3 plot-benchmark.py
```

### 4. Curatare

```bash
make clean
make clean-all
```

---

## Clase de Teste

- **Random 10%/30%/67%** - Grafuri aleatorii cu diferite densitati
- **Bipartite** - Grafuri bipartite (teorema lui Konig)
- **Cycle-with-cords** - Cicluri hamiltoniene cu coarde random

Toate grafurile au **N ≤ 20 noduri** pentru a permite calculul solutiei optime cu brute-force.

## Rezultate

Pe un set de 500 de teste (100 per clasa), euristica **greedy-remove-edges** obtine:
- **84.4%** solutii optime
- **98.6%** acuratete medie
- Timp de executie similar cu greedy simplu

Detalii complete in `report.pdf`.