CsvImportMagic::Engine.routes.draw do
  resources :importers, only: [:create, :edit, :update]
end
