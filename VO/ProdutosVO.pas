unit ProdutosVO;

interface

Type TProdutosVO = class
  private
    Fpreco_venda: double;
    Fdescricao: String;
    Fcodigo: integer;
    procedure Setcodigo(const Value: integer);
    procedure Setdescricao(const Value: String);
    procedure Setpreco_venda(const Value: double);
  published

   property codigo: integer read Fcodigo write Setcodigo;
   property descricao: String read Fdescricao write Setdescricao;
   property preco_venda: double read Fpreco_venda write Setpreco_venda;

end;

implementation

{ TProdutosVO }

procedure TProdutosVO.Setcodigo(const Value: integer);
begin
  Fcodigo := Value;
end;

procedure TProdutosVO.Setdescricao(const Value: String);
begin
  Fdescricao := Value;
end;

procedure TProdutosVO.Setpreco_venda(const Value: double);
begin
  Fpreco_venda := Value;
end;

end.
