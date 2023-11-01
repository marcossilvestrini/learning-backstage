import os
import subprocess

# Definindo diretórios
SOURCE_DIR = r"F:\Projetos\learnin-backstage\backstage\skynet"
DEST_DIR = r"F:\Projetos\backstage\server"

def execute_command(cmd, working_dir):
    """Executa um comando no diretório especificado."""
    subprocess.run(cmd, cwd=working_dir, shell=True, check=True)

def main():
    # Copiar arquivos
    os.system(f'xcopy /s /y "{SOURCE_DIR}" "{DEST_DIR}"')

    # Configura o Git para não dar aviso de "pathspec"
    execute_command("git config core.protectNTFS false", DEST_DIR)

    # Adicionar mudanças ao índice
    execute_command("git add .", DEST_DIR)

    # Commitar as mudanças
    commit_message = "💚 upd: sync repository for build"
    execute_command(f'git commit -m "{commit_message}"', DEST_DIR)

    # Push para o repositório remoto
    execute_command("git push", DEST_DIR)

if __name__ == "__main__":
    main()
