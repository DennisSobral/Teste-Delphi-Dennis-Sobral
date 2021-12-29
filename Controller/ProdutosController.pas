unit ProdutosController;

interface

uses ProdutosVO, generics.collections, System.SysUtils, FireDAC.Comp.Client, FireDAC.DApt;

Type TProdutosController = class

   class Function RetornarProdutoPorID(id: integer): TProdutosVO;

end;

implementation

uses untprincipal;

{ TProdutosController }

class function TProdutosController.RetornarProdutoPorID(id: integer): TProdutosVO;
Var query: TFDQuery;
    produto: TProdutosVO;
begin

   Try

      produto := TProdutosVO.Create;

      query := TFDQuery.Create(Nil);
      query.Connection := frmPrincipal.Conexao;

      query.SQL.Add('SELECT * FROM produtos WHERE codigo = '+id.tostring);
      query.Open;

      if Not(query.IsEmpty) then Begin

         produto.codigo      := query.FieldByName('codigo').AsInteger;
         produto.descricao   := Trim(query.FieldByName('descricao').AsString);
         produto.preco_venda := query.FieldByName('valor_venda').AsFloat;

      End;

      Result := produto;

   Finally

      FreeAndNil(query);

   End;

end;

end.
