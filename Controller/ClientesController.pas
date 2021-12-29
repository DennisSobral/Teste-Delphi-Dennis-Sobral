unit ClientesController;

interface

uses ClientesVO, generics.collections, System.SysUtils, FireDAC.Comp.Client, FireDAC.DApt;

Type TClientesController = class

   class Function RetornarClientePorID(id: integer): TClientesVO;

end;

implementation

uses untPrincipal;

{ TClientesController }

class function TClientesController.RetornarClientePorID(id: integer): TClientesVO;
Var query: TFDQuery;
    cliente: TClientesVO;
begin

   Try

      cliente := TClientesVO.Create;

      query := TFDQuery.Create(Nil);
      query.Connection := frmPrincipal.Conexao;

      query.SQL.Add('SELECT * FROM clientes WHERE codigo = '+id.tostring);
      query.Open;

      if Not(query.IsEmpty) then Begin

         cliente.codigo := query.FieldByName('codigo').AsInteger;
         cliente.nome   := Trim(query.FieldByName('nome').AsString);
         cliente.cidade := Trim(query.FieldByName('cidade').AsString);
         cliente.uf     := Trim(query.FieldByName('uf').AsString);

      End;

      Result := cliente;


   Finally

      FreeAndNil(query);

   End;

end;

end.
