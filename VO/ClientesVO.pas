unit ClientesVO;

interface

Type TClientesVO = class
  private
    Fuf: String;
    Fcodigo: integer;
    Fnome: String;
    Fcidade: String;
    procedure Setcidade(const Value: String);
    procedure Setcodigo(const Value: integer);
    procedure Setnome(const Value: String);
    procedure Setuf(const Value: String);
  published

   property codigo: integer read Fcodigo write Setcodigo;
   property nome: String read Fnome write Setnome;
   property cidade: String read Fcidade write Setcidade;
   property uf: String read Fuf write Setuf;

end;

implementation

{ TClientesVO }

procedure TClientesVO.Setcidade(const Value: String);
begin
  Fcidade := Value;
end;

procedure TClientesVO.Setcodigo(const Value: integer);
begin
  Fcodigo := Value;
end;

procedure TClientesVO.Setnome(const Value: String);
begin
  Fnome := Value;
end;

procedure TClientesVO.Setuf(const Value: String);
begin
  Fuf := Value;
end;

end.
