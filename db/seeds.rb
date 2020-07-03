# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create([
              { admin: true, email: 'admin@autoforce.com.br', name: 'Usuário admin', password: '123456' }
              # ,{ admin: false, email: 'user_teste_02@autoforce.com.br', name: 'Usuário Teste 01', password: '123456' }
              # ,{ admin: false, email: 'user_teste_01@autoforce.com.br', name: 'Usuário Teste 02', password: '123456' }
            ])
