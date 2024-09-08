# neovim 설정

## vim plug

https://github.com/junegunn/vim-plug

vim plug 설치 후
neovim에서 `:PlugInstall` 수행

## 언어서버

아래 주소 참고
https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

### js, ts
[typescript-language-server](https://github.com/typescript-language-server/typescript-language-server)

#### vue
[@vue/language-server](https://github.com/vuejs/language-tools) 참고
- global node_modules에 `@vue/language-server`, `@vue/typescript-plugin` 필요

### json
[vscode-json-languageserver](https://github.com/microsoft/vscode/tree/main/extensions/json-language-features/server)

### python
[pyright](https://github.com/microsoft/pyright)
- 홈 디렉토리에서 일회용 파일 작성하는 경우 전체를 검색하는 문제가 있음
    - 홈에 아래처럼 `pyrightconfig.json` 작성해서 방지할 수 있음
    ```json
    {
        "exclude": [
                "./**/*"
        ]
    }
    ```
