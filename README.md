

# baixe o repositorio
git clone https://github.com/lndgoncalves/docker-laravel.git docker-laravel
cd docker-laravel

# Criar/instalar uma imagem do composer
docker run --rm -v $(pwd):/app composer install

# Edite o arquivo docker-compose.yml e altere as senhas 

# Suba todos os containers
docker-compose up -d

# Acesse seu navegador e verifique se a pagina do laravel aparece
http://localhost


# para verificar se subiu 
docker ps

# você pode gerar as chaves 
docker-compose exec app php artisan key:generate

# colocar os arquivos em cache
docker-compose exec app php artisan config:cache

# Executar o MIGRATION
docker-compose exec app php artisan migrate

# Assim que a migração for concluída, você pode fazer uma consulta para verificar se está devidamente conectado ao banco de dados usando o comando tinker:
docker-compose exec app php artisan tinker

\DB::table('migrations')->get();
