from pathlib import Path

for i in range(2):
    for j in range(4):
        path = Path(f'h{i}{j}-box-rad4.txt')
        lines = path.read_text().strip().splitlines()
        path.write_text('\n'.join(sorted(lines)) + '\n')
