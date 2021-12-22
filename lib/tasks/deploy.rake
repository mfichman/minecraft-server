task deploy: ['docker:build', 'docker:push'] do
  sh 'make -C ../smart-hub minecraft.up'
end
