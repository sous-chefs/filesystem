# frozen_string_literal: true

name 'filesystem'

run_list 'test::default', 'test::nfs'

cookbook 'filesystem', path: '.'
cookbook 'lvm', git: 'https://github.com/sous-chefs/lvm.git', branch: 'main'
cookbook 'test', path: './test/cookbooks/test'

Dir.children('./test/cookbooks/test/recipes').grep(/\.rb\z/).sort.each do |recipe|
  recipe_name = File.basename(recipe, '.rb')
  next if recipe_name == 'default'

  named_run_list recipe_name.to_sym, 'test::' + recipe_name
end

named_run_list :default, 'test::default', 'test::nfs'
