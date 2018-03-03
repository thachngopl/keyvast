{ KeyVast - A key value store }
{ Copyright (c) 2018 KeyVast, David J Butler }
{ KeyVast is released under the terms of the MIT license. }

{ 2018/02/09  0.01  Initial version (int, str, float, list, dict) }
{ 2018/02/14  0.02  List and dictionary accessor functions }
{ 2018/02/16  0.03  Boolean }
{ 2018/02/17  0.04  Binary operators }
{ 2018/02/18  0.05  Null value, DateTime }
{ 2018/02/26  0.06  VarWord32 encoding }
{ 2018/03/01  0.07  Binary value }

// todo: hugeint, decimals

{$INCLUDE kvInclude.inc}

unit kvValues;

interface

uses
  SysUtils;



const
  KV_Value_TypeId_Integer    = $01;
  KV_Value_TypeId_String     = $02;
  KV_Value_TypeId_Float      = $03;
  KV_Value_TypeId_Boolean    = $04;
  KV_Value_TypeId_DateTime   = $05;
  KV_Value_TypeId_Binary     = $06;
  KV_Value_TypeId_Null       = $10;
  KV_Value_TypeId_List       = $20;
  KV_Value_TypeId_Dictionary = $21;
  KV_Value_TypeId_Other      = $FF;



type
  kvByteArray = array of Byte;

  EkvValue = class(Exception);

  AkvValue = class
  protected
    function  GetAsString: String; virtual; abstract;
    function  GetAsScript: String; virtual;
    function  GetAsBoolean: Boolean; virtual;
    function  GetAsFloat: Double; virtual;
    function  GetAsInteger: Int64; virtual;
    function  GetAsDateTime: TDateTime; virtual;
    function  GetAsBinary: kvByteArray; virtual;
    procedure SetAsString(const A: String); virtual;
    procedure SetAsBoolean(const A: Boolean); virtual;
    procedure SetAsFloat(const A: Double); virtual;
    procedure SetAsInteger(const A: Int64); virtual;
    procedure SetAsDateTime(const A: TDateTime); virtual;
    procedure SetAsBinary(const A: kvByteArray); virtual;
    function  GetTypeId: Byte; virtual;
    function  GetSerialSize: Integer; virtual;
  public
    function  Duplicate: AkvValue; virtual; abstract;
    property  AsString: String read GetAsString write SetAsString;
    property  AsScript: String read GetAsScript;
    property  AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property  AsFloat: Double read GetAsFloat write SetAsFloat;
    property  AsInteger: Int64 read GetAsInteger write SetAsInteger;
    property  AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property  AsBinary: kvByteArray read GetAsBinary write SetAsBinary;
    procedure Negate; virtual;
    property  TypeId: Byte read GetTypeId;
    property  SerialSize: Integer read GetSerialSize;
    function  GetSerialBuf(var Buf; const BufSize: Integer): Integer; virtual;
    function  PutSerialBuf(const Buf; const BufSize: Integer): Integer; virtual;
  end;
  TkvValueArray = array of AkvValue;

  TkvIntegerValue = class(AkvValue)
  private
    FValue : Int64;
  protected
    function  GetAsString: String; override;
    function  GetAsBoolean: Boolean; override;
    function  GetAsFloat: Double; override;
    function  GetAsInteger: Int64; override;
    procedure SetAsString(const A: String); override;
    procedure SetAsBoolean(const A: Boolean); override;
    procedure SetAsInteger(const A: Int64); override;
    function  GetTypeId: Byte; override;
    function  GetSerialSize: Integer; override;
  public
    constructor Create; overload;
    constructor Create(const Value: Int64); overload;
    property  Value: Int64 read FValue write FValue;
    function  Duplicate: AkvValue; override;
    procedure Negate; override;
    function  GetSerialBuf(var Buf; const BufSize: Integer): Integer; override;
    function  PutSerialBuf(const Buf; const BufSize: Integer): Integer; override;
  end;

  TkvStringValue = class(AkvValue)
  private
    FValue : String;
  protected
    function  GetAsString: String; override;
    function  GetAsScript: String; override;
    function  GetAsBoolean: Boolean; override;
    function  GetAsFloat: Double; override;
    function  GetAsInteger: Int64; override;
    function  GetAsDateTime: TDateTime; override;
    function  GetAsBinary: kvByteArray; override;
    procedure SetAsString(const A: String); override;
    function  GetTypeId: Byte; override;
    function  GetSerialSize: Integer; override;
  public
    constructor Create; overload;
    constructor Create(const Value: String); overload;
    property  Value: String read FValue write FValue;
    function  Duplicate: AkvValue; override;
    function  GetSerialBuf(var Buf; const BufSize: Integer): Integer; override;
    function  PutSerialBuf(const Buf; const BufSize: Integer): Integer; override;
  end;

  TkvFloatValue = class(AkvValue)
  private
    FValue : Double;
  protected
    function  GetAsString: String; override;
    function  GetAsFloat: Double; override;
    procedure SetAsFloat(const A: Double); override;
    procedure SetAsInteger(const A: Int64); override;
    function  GetTypeId: Byte; override;
    function  GetSerialSize: Integer; override;
  public
    constructor Create; overload;
    constructor Create(const Value: Double); overload;
    property  Value: Double read FValue write FValue;
    function  Duplicate: AkvValue; override;
    procedure Negate; override;
    function  GetSerialBuf(var Buf; const BufSize: Integer): Integer; override;
    function  PutSerialBuf(const Buf; const BufSize: Integer): Integer; override;
  end;

  TkvBooleanValue = class(AkvValue)
  private
    FValue : Boolean;
  protected
    function  GetAsString: String; override;
    function  GetAsBoolean: Boolean; override;
    procedure SetAsString(const A: String); override;
    procedure SetAsBoolean(const A: Boolean); override;
    function  GetTypeId: Byte; override;
    function  GetSerialSize: Integer; override;
  public
    constructor Create; overload;
    constructor Create(const Value: Boolean); overload;
    property  Value: Boolean read FValue write FValue;
    function  Duplicate: AkvValue; override;
    function  GetSerialBuf(var Buf; const BufSize: Integer): Integer; override;
    function  PutSerialBuf(const Buf; const BufSize: Integer): Integer; override;
  end;

  TkvDateTimeValue = class(AkvValue)
  private
    FValue : TDateTime;
  protected
    function  GetAsString: String; override;
    function  GetAsScript: String; override;
    function  GetAsDateTime: TDateTime; override;
    procedure SetAsDateTime(const A: TDateTime); override;
    function  GetTypeId: Byte; override;
    function  GetSerialSize: Integer; override;
  public
    constructor Create; overload;
    constructor Create(const Value: TDateTime); overload;
    property  Value: TDateTime read FValue write FValue;
    function  Duplicate: AkvValue; override;
    function  GetSerialBuf(var Buf; const BufSize: Integer): Integer; override;
    function  PutSerialBuf(const Buf; const BufSize: Integer): Integer; override;
  end;

  TkvBinaryValue = class(AkvValue)
  private
    FValue : kvByteArray;
  protected
    function  GetAsString: String; override;
    function  GetAsScript: String; override;
    function  GetAsBinary: kvByteArray; override;
    procedure SetAsString(const A: String); override;
    procedure SetAsBinary(const A: kvByteArray); override;
    function  GetTypeId: Byte; override;
    function  GetSerialSize: Integer; override;
  public
    constructor Create; overload;
    constructor Create(const Value: kvByteArray); overload;
    constructor Create(const Value: Byte); overload;
    function  Duplicate: AkvValue; override;
    function  GetSerialBuf(var Buf; const BufSize: Integer): Integer; override;
    function  PutSerialBuf(const Buf; const BufSize: Integer): Integer; override;
  end;

  TkvNullValue = class(AkvValue)
  protected
    function  GetAsString: String; override;
    function  GetTypeId: Byte; override;
    function  GetSerialSize: Integer; override;
  public
    function  Duplicate: AkvValue; override;
    function  GetSerialBuf(var Buf; const BufSize: Integer): Integer; override;
    function  PutSerialBuf(const Buf; const BufSize: Integer): Integer; override;
  end;

  TkvListValue = class(AkvValue)
  private
    FValue : array of AkvValue;
  protected
    function  GetAsString: String; override;
    function  GetTypeId: Byte; override;
    function  GetSerialSize: Integer; override;
  public
    destructor Destroy; override;
    function  GetCount: Integer;
    function  Duplicate: AkvValue; override;
    function  GetSerialBuf(var Buf; const BufSize: Integer): Integer; override;
    function  PutSerialBuf(const Buf; const BufSize: Integer): Integer; override;
    procedure Add(const Value: AkvValue);
    function  GetValue(const Index: Integer): AkvValue;
    procedure SetValue(const Index: Integer; const Value: AkvValue);
    procedure DeleteValue(const Index: Integer);
    procedure InsertValue(const Index: Integer; const Value: AkvValue);
    procedure AppendValue(const Value: AkvValue);
  end;

  TkvDictionaryKeyValuePair = record
    Key   : String;
    Value : AkvValue;
  end;
  PkvDictionaryKeyValuePair = ^TkvDictionaryKeyValuePair;

  TkvDictionaryValue = class(AkvValue)
  private
    FValue : array of TkvDictionaryKeyValuePair;
  protected
    function  GetAsString: String; override;
    function  GetTypeId: Byte; override;
    function  GetSerialSize: Integer; override;
    function  GetKeyIndex(const Key: String): Integer;
  public
    destructor Destroy; override;
    function  Duplicate: AkvValue; override;
    function  GetSerialBuf(var Buf; const BufSize: Integer): Integer; override;
    function  PutSerialBuf(const Buf; const BufSize: Integer): Integer; override;
    procedure Add(const Key: String; const Value: AkvValue);
    procedure AddString(const Key: String; const Value: String);
    procedure AddBoolean(const Key: String; const Value: Boolean);
    procedure AddFloat(const Key: String; const Value: Double);
    procedure AddInteger(const Key: String; const Value: Int64);
    procedure AddDateTime(const Key: String; const Value: TDateTime);
    function  Exists(const Key: String): Boolean;
    function  GetValue(const Key: String): AkvValue;
    function  GetValueAsString(const Key: String): String;
    function  GetValueAsBoolean(const Key: String): Boolean;
    function  GetValueAsFloat(const Key: String): Double;
    function  GetValueAsInteger(const Key: String): Int64;
    function  GetValueAsDateTime(const Key: String): TDateTime;
    procedure SetValue(const Key: String; const Value: AkvValue);
    procedure SetValueString(const Key: String; const Value: String);
    procedure SetValueInteger(const Key: String; const Value: Int64);
    procedure SetValueDateTime(const Key: String; const Value: TDateTime);
    procedure DeleteValue(const Key: String);
    function  GetCount: Integer;
    function  GetItem(const Idx: Integer): PkvDictionaryKeyValuePair;
  end;



{ Factory function }

function kvCreateValueFromTypeId(const TypeId: Integer): AkvValue;



{ Value operators }

function ValueOpPlus(const A, B: AkvValue): AkvValue;
function ValueOpMinus(const A, B: AkvValue): AkvValue;
function ValueOpMultiply(const A, B: AkvValue): AkvValue;
function ValueOpDivide(const A, B: AkvValue): AkvValue;

function ValueOpOR(const A, B: AkvValue): AkvValue;
function ValueOpXOR(const A, B: AkvValue): AkvValue;
function ValueOpAND(const A, B: AkvValue): AkvValue;
function ValueOpNOT(const A: AkvValue): AkvValue;

function ValueOpCompare(const A, B: AkvValue): Integer;



{ VarWord32 functions }

type
  Int32 = FixedInt;
  PInt32 = ^Int32;
  Word32 = FixedUInt;
  PWord32 = ^Word32;

function kvVarWord32EncodedSize(const A: Word32): Integer;
function kvVarWord32EncodeBuf(const A: Word32; var Buf; const BufSize: Integer): Integer;
function kvVarWord32DecodeBuf(const Buf; const BufSize: Integer; out A: Word32): Integer;



implementation

uses
  StrUtils;



const
  SInvalidBufferSize = 'Invalid buffer size';



{ VarWord32 functions }

function kvVarWord32EncodedSize(const A: Word32): Integer;
begin
  if A <= $7F then
    Result := 1
  else
    Result := 4;
end;

function kvVarWord32EncodeBuf(const A: Word32; var Buf; const BufSize: Integer): Integer;
var
  E : Word32;
begin
  if A <= $7F then
    begin
      if BufSize < 1 then
        raise EkvValue.Create(SInvalidBufferSize);
      PByte(@Buf)^ := Byte(A);
      Result := 1;
    end
  else
  if A >= $80000000 then
    raise EkvValue.Create('VarInt value overflow')
  else
    begin
      if BufSize < 4 then
        raise EkvValue.Create(SInvalidBufferSize);
      E := (A and $7F) or $80 or ((A shl 1) and $FFFFFF00);
      PWord32(@Buf)^ := E;
      Result := 4;
    end;
end;

function kvVarWord32DecodeBuf(const Buf; const BufSize: Integer; out A: Word32): Integer;
var
  B : Byte;
  E : Word32;
begin
  if BufSize < 1 then
    raise EkvValue.Create(SInvalidBufferSize);
  B := PByte(@Buf)^;
  if B and $80 = 0 then
    begin
      A := B;
      Result := 1;
    end
  else
    begin
      if BufSize < 4 then
        raise EkvValue.Create(SInvalidBufferSize);
      E := PWord32(@Buf)^;
      A := (E and $7F) or ((E shr 1) and $FFFFFF80);
      Result := 4;
    end;
end;



{ Factory function }

function kvCreateValueFromTypeId(const TypeId: Integer): AkvValue;
begin
  case TypeId of
    KV_Value_TypeId_Integer    : Result := TkvIntegerValue.Create;
    KV_Value_TypeId_String     : Result := TkvStringValue.Create;
    KV_Value_TypeId_Float      : Result := TkvFloatValue.Create;
    KV_Value_TypeId_Boolean    : Result := TkvBooleanValue.Create;
    KV_Value_TypeId_DateTime   : Result := TkvDateTimeValue.Create;
    KV_Value_TypeId_Binary     : Result := TkvBinaryValue.Create;
    KV_Value_TypeId_Null       : Result := TkvNullValue.Create;
    KV_Value_TypeId_List       : Result := TkvListValue.Create;
    KV_Value_TypeId_Dictionary : Result := TkvDictionaryValue.Create;
  else
    raise EkvValue.Create('Invalid value type id');
  end;
end;



{ AkvValue }

function AkvValue.GetAsScript: String;
begin
  Result := GetAsString;
end;

function AkvValue.GetAsBoolean: Boolean;
begin
  raise EkvValue.CreateFmt('Type conversion error: %s cannot convert to a boolean value', [ClassName]);
end;

function AkvValue.GetAsFloat: Double;
begin
  raise EkvValue.CreateFmt('Type conversion error: %s cannot convert to a float value', [ClassName]);
end;

function AkvValue.GetAsInteger: Int64;
begin
  raise EkvValue.CreateFmt('Type conversion error: %s cannot convert to a integer value', [ClassName]);
end;

function AkvValue.GetAsDateTime: TDateTime;
begin
  raise EkvValue.CreateFmt('Type conversion error: %s cannot convert to a datetime value', [ClassName]);
end;

function AkvValue.GetAsBinary: kvByteArray;
begin
  raise EkvValue.CreateFmt('Type conversion error: %s cannot convert to a binary value', [ClassName]);
end;

procedure AkvValue.SetAsString(const A: String);
begin
  raise EkvValue.CreateFmt('Type conversion error: %s cannot set from a string value', [ClassName]);
end;

procedure AkvValue.SetAsBoolean(const A: Boolean);
begin
  raise EkvValue.CreateFmt('Type conversion error: %s cannot set from a boolean value', [ClassName]);
end;

procedure AkvValue.SetAsFloat(const A: Double);
begin
  raise EkvValue.CreateFmt('Type conversion error: %s cannot set from a float value', [ClassName]);
end;

procedure AkvValue.SetAsInteger(const A: Int64);
begin
  raise EkvValue.CreateFmt('Type conversion error: %s cannot set from a integer value', [ClassName]);
end;

procedure AkvValue.SetAsDateTime(const A: TDateTime);
begin
  raise EkvValue.CreateFmt('Type conversion error: %s cannot set from a datetime value', [ClassName]);
end;

procedure AkvValue.SetAsBinary(const A: kvByteArray);
begin
  raise EkvValue.CreateFmt('Type conversion error: %s cannot set from a binary value', [ClassName]);
end;

procedure AkvValue.Negate;
begin
  raise EkvValue.CreateFmt('Invalid operation on type: %s cannot negate', [ClassName]);
end;

function AkvValue.GetTypeId: Byte;
begin
  raise EkvValue.CreateFmt('Type serialisation error: %s has no type id', [ClassName]);
end;

function AkvValue.GetSerialSize: Integer;
begin
  raise EkvValue.CreateFmt('Type serialisation error: %s cannot serialise', [ClassName]);
end;

function AkvValue.GetSerialBuf(var Buf; const BufSize: Integer): Integer;
begin
  raise EkvValue.CreateFmt('Type serialisation error: %s cannot serialise', [ClassName]);
end;

function AkvValue.PutSerialBuf(const Buf; const BufSize: Integer): Integer;
begin
  raise EkvValue.CreateFmt('Type serialisation error: %s cannot serialise', [ClassName]);
end;



{ TkvIntegerValue }

constructor TkvIntegerValue.Create;
begin
  inherited Create;
end;

constructor TkvIntegerValue.Create(const Value: Int64);
begin
  inherited Create;
  FValue := Value;
end;

function TkvIntegerValue.GetAsString: String;
begin
  Result := IntToStr(FValue);
end;

function TkvIntegerValue.GetAsBoolean: Boolean;
begin
  Result := FValue <> 0;
end;

function TkvIntegerValue.GetAsFloat: Double;
begin
  Result := FValue;
end;

function TkvIntegerValue.GetAsInteger: Int64;
begin
  Result := FValue;
end;

procedure TkvIntegerValue.SetAsString(const A: String);
begin
  if not TryStrToInt64(A, FValue) then
    raise EkvValue.Create('Type conversion error: Invalid integer string value');
end;

procedure TkvIntegerValue.SetAsBoolean(const A: Boolean);
begin
  FValue := Ord(A);
end;

procedure TkvIntegerValue.SetAsInteger(const A: Int64);
begin
  FValue := A;
end;

function TkvIntegerValue.GetTypeId: Byte;
begin
  Result := KV_Value_TypeId_Integer;
end;

procedure TkvIntegerValue.Negate;
begin
  FValue := -FValue;
end;

function TkvIntegerValue.Duplicate: AkvValue;
begin
  Result := TkvIntegerValue.Create(FValue);
end;

function TkvIntegerValue.GetSerialSize: Integer;
begin
  Result := SizeOf(Int64);
end;

function TkvIntegerValue.GetSerialBuf(var Buf; const BufSize: Integer): Integer;
begin
  if BufSize < SizeOf(Int64) then
    raise EkvValue.Create(SInvalidBufferSize);
  PInt64(@Buf)^ := FValue;
  Result := SizeOf(Int64);
end;

function TkvIntegerValue.PutSerialBuf(const Buf; const BufSize: Integer): Integer;
begin
  if BufSize < SizeOf(Int64) then
    raise EkvValue.Create(SInvalidBufferSize);
  FValue := PInt64(@Buf)^;
  Result := SizeOf(Int64);
end;



{ TkvStringValue }

constructor TkvStringValue.Create;
begin
  inherited Create;
end;

constructor TkvStringValue.Create(const Value: String);
begin
  inherited Create;
  FValue := Value;
end;

function TkvStringValue.Duplicate: AkvValue;
begin
  Result := TkvStringValue.Create(FValue);
end;

function TkvStringValue.GetAsString: String;
begin
  Result := FValue;
end;

procedure TkvStringValue.SetAsString(const A: String);
begin
  FValue := A;
end;

function TkvStringValue.GetAsScript: String;
begin
  Result := '"' + ReplaceStr(FValue, '"', '""') + '"';
end;

function TkvStringValue.GetAsBoolean: Boolean;
begin
  if SameText(FValue, 'true') then
    Result := True
  else
  if SameText(FValue, 'false') then
    Result := False
  else
    raise EkvValue.Create('Type conversion error: Not a boolean value');
end;

function TkvStringValue.GetAsFloat: Double;
begin
  if not TryStrToFloat(FValue, Result) then
    raise EkvValue.Create('Type conversion error: Not a float value');
end;

function TkvStringValue.GetAsInteger: Int64;
begin
  if not TryStrToInt64(FValue, Result) then
    raise EkvValue.Create('Type conversion error: Not an integer value');
end;

function TkvStringValue.GetAsDateTime: TDateTime;
begin
  if not TryStrToDateTime(FValue, Result) then
    raise EkvValue.Create('Type conversion error: Not a date/time value');
end;

function TkvStringValue.GetAsBinary: kvByteArray;
var
  R : kvByteArray;
  I, L : Integer;
  C : WideChar;
begin
  L := Length(FValue);
  SetLength(R, L);
  for I := 0 to L - 1 do
    begin
      C := FValue.Chars[I];
      if Ord(C) > $FF then
        raise EkvValue.Create('Type conversion error: Not a valid binary string');
      R[I] := Byte(Ord(C));
    end;
  Result := R;
end;

function TkvStringValue.GetTypeId: Byte;
begin
  Result := KV_Value_TypeId_String;
end;

function TkvStringValue.GetSerialSize: Integer;
var
  L : Integer;
begin
  L := Length(FValue);
  Result := kvVarWord32EncodedSize(L) + L * SizeOf(Char);
end;

function TkvStringValue.GetSerialBuf(var Buf; const BufSize: Integer): Integer;
var
  L : Int32;
  N : Integer;
  M : Integer;
  P : PByte;
begin
  L := Length(FValue);
  N := kvVarWord32EncodedSize(L);
  M := N + L * SizeOf(Char);
  if BufSize < M then
    raise EkvValue.Create(SInvalidBufferSize);
  P := @Buf;
  kvVarWord32EncodeBuf(L, P^, N);
  Inc(P, N);
  if L > 0 then
    Move(PChar(FValue)^, P^, L * SizeOf(Char));
  Result := M;
end;

function TkvStringValue.PutSerialBuf(const Buf; const BufSize: Integer): Integer;
var
  P : PByte;
  L : Integer;
  N : Integer;
  Len : Word32;
  M : Int32;
  S : String;
begin
  P := @Buf;
  L := BufSize;

  N := kvVarWord32DecodeBuf(P^, L, Len);
  Dec(L, N);
  Inc(P, N);
  if Int32(Len) < 0 then
    raise EkvValue.Create('Invalid buffer: string length');

  M := Int32(Len) * SizeOf(Char);
  if L < M then
    raise EkvValue.Create(SInvalidBufferSize);
  Dec(L, M);
  SetLength(S, Len);
  if Len > 0 then
    Move(P^, PChar(S)^, M);
  FValue := S;

  Result := BufSize - L;
end;



{ TkvFloatValue }

constructor TkvFloatValue.Create;
begin
  inherited Create;
end;

constructor TkvFloatValue.Create(const Value: Double);
begin
  inherited Create;
  FValue := Value;
end;

function TkvFloatValue.Duplicate: AkvValue;
begin
  Result := TkvFloatValue.Create(FValue);
end;

function TkvFloatValue.GetAsFloat: Double;
begin
  Result := FValue;
end;

function TkvFloatValue.GetAsString: String;
begin
  Result := FloatToStr(FValue);
end;

procedure TkvFloatValue.SetAsFloat(const A: Double);
begin
  FValue := A;
end;

procedure TkvFloatValue.SetAsInteger(const A: Int64);
begin
  FValue := A;
end;

function TkvFloatValue.GetTypeId: Byte;
begin
  Result := KV_Value_TypeId_Float;
end;

procedure TkvFloatValue.Negate;
begin
  FValue := -FValue;
end;

function TkvFloatValue.GetSerialSize: Integer;
begin
  Result := SizeOf(Double);
end;

function TkvFloatValue.GetSerialBuf(var Buf; const BufSize: Integer): Integer;
begin
  if BufSize < SizeOf(Double) then
    raise EkvValue.Create(SInvalidBufferSize);
  PDouble(@Buf)^ := FValue;
  Result := SizeOf(Double);
end;

function TkvFloatValue.PutSerialBuf(const Buf; const BufSize: Integer): Integer;
begin
  if BufSize < SizeOf(Double) then
    raise EkvValue.Create(SInvalidBufferSize);
  FValue := PDouble(@Buf)^;
  Result := SizeOf(Double);
end;



{ TkvBooleanValue }

constructor TkvBooleanValue.Create;
begin
  inherited Create;
end;

constructor TkvBooleanValue.Create(const Value: Boolean);
begin
  inherited Create;
  FValue := Value;
end;

function TkvBooleanValue.Duplicate: AkvValue;
begin
  Result := TkvBooleanValue.Create(FValue);
end;

function TkvBooleanValue.GetAsString: String;
begin
  if GetAsBoolean then
    Result := 'true'
  else
    Result := 'false';
end;

function TkvBooleanValue.GetAsBoolean: Boolean;
begin
  Result := FValue;
end;

procedure TkvBooleanValue.SetAsString(const A: String);
begin
  if A = 'true' then
    FValue := True
  else
  if A = 'false' then
    FValue := False
  else
    raise EkvValue.Create('Type conversion error: Not a boolean string value');
end;

procedure TkvBooleanValue.SetAsBoolean(const A: Boolean);
begin
  FValue := A;
end;

function TkvBooleanValue.GetTypeId: Byte;
begin
  Result := KV_Value_TypeId_Boolean;
end;

function TkvBooleanValue.GetSerialSize: Integer;
begin
  Result := SizeOf(Boolean);
end;

function TkvBooleanValue.GetSerialBuf(var Buf; const BufSize: Integer): Integer;
begin
  if BufSize < SizeOf(Byte) then
    raise EkvValue.Create(SInvalidBufferSize);
  PByte(@Buf)^ := Ord(FValue);
  Result := SizeOf(Byte);
end;

function TkvBooleanValue.PutSerialBuf(const Buf; const BufSize: Integer): Integer;
begin
  if BufSize < SizeOf(Byte) then
    raise EkvValue.Create(SInvalidBufferSize);
  FValue := PByte(@Buf)^ <> 0;
  Result := SizeOf(Double);
end;



{ TkvDateTimeValue }

constructor TkvDateTimeValue.Create;
begin
  inherited Create;
end;

constructor TkvDateTimeValue.Create(const Value: TDateTime);
begin
  inherited Create;
  FValue := Value;
end;

function TkvDateTimeValue.Duplicate: AkvValue;
begin
  Result := TkvDateTimeValue.Create(FValue);
end;

function TkvDateTimeValue.GetAsString: String;
begin
  Result := DateTimeToStr(FValue);
end;

function TkvDateTimeValue.GetAsScript: String;
begin
  Result := 'DATETIME("' + GetAsString + '")';
end;

function TkvDateTimeValue.GetAsDateTime: TDateTime;
begin
  Result := FValue;
end;

procedure TkvDateTimeValue.SetAsDateTime(const A: TDateTime);
begin
  FValue := A;
end;

function TkvDateTimeValue.GetTypeId: Byte;
begin
  Result := KV_Value_TypeId_DateTime;
end;

function TkvDateTimeValue.GetSerialSize: Integer;
begin
  Result := SizeOf(TDateTime);
end;

function TkvDateTimeValue.GetSerialBuf(var Buf; const BufSize: Integer): Integer;
begin
  if BufSize < SizeOf(TDateTime) then
    raise EkvValue.Create(SInvalidBufferSize);
  PDateTime(@Buf)^ := FValue;
  Result := SizeOf(TDateTime);
end;

function TkvDateTimeValue.PutSerialBuf(const Buf; const BufSize: Integer): Integer;
begin
  if BufSize < SizeOf(TDateTime) then
    raise EkvValue.Create(SInvalidBufferSize);
  FValue := PDateTime(@Buf)^;
  Result := SizeOf(TDateTime);
end;



{ TkvBinaryValue }

constructor TkvBinaryValue.Create;
begin
  inherited Create;
end;

constructor TkvBinaryValue.Create(const Value: kvByteArray);
begin
  inherited Create;
  FValue := Copy(Value);
end;

constructor TkvBinaryValue.Create(const Value: Byte);
begin
  inherited Create;
  SetLength(FValue, 1);
  FValue[0] := Value;
end;

function TkvBinaryValue.Duplicate: AkvValue;
begin
  Result := TkvBinaryValue.Create(FValue);
end;

function TkvBinaryValue.GetAsString: String;
var
  I, L : Integer;
  S : String;
  P : PChar;
begin
  L := Length(FValue);
  SetLength(S, L);
  P := PChar(S);
  for I := 0 to L - 1 do
    begin
      P^ := WideChar(FValue[I]);
      Inc(P);
    end;
  Result := S;
end;

function TkvBinaryValue.GetAsScript: String;
var
  S : String;
  I : Integer;
begin
  S := '';
  for I := 0 to Length(FValue) - 1 do
    begin
      if I > 0 then
        S := S + ' + ';
      S := S + 'BYTE(' + IntToStr(FValue[I]) + ')';
    end;
  Result := S;
end;

function TkvBinaryValue.GetAsBinary: kvByteArray;
begin
  Result := FValue;
end;

procedure TkvBinaryValue.SetAsString(const A: String);
var
  I, L : Integer;
  C : WideChar;
begin
  L := Length(A);
  SetLength(FValue, L);
  for I := 0 to L - 1 do
    begin
      C := A.Chars[I];
      if Ord(C) > $FF then
        raise EkvValue.Create('Type conversion error: Not a valid binary string');
      FValue[I] := Byte(Ord(C));
    end;
end;

procedure TkvBinaryValue.SetAsBinary(const A: kvByteArray);
begin
  FValue := Copy(A);
end;

function TkvBinaryValue.GetTypeId: Byte;
begin
  Result := KV_Value_TypeId_Binary;
end;

function TkvBinaryValue.GetSerialSize: Integer;
var
  L : Integer;
begin
  L := Length(FValue);
  Result := kvVarWord32EncodedSize(L) + L;
end;

function TkvBinaryValue.GetSerialBuf(var Buf; const BufSize: Integer): Integer;
var
  L : Int32;
  N : Integer;
  M : Integer;
  P : PByte;
begin
  L := Length(FValue);
  N := kvVarWord32EncodedSize(L);
  M := N + L;
  if BufSize < M then
    raise EkvValue.Create(SInvalidBufferSize);
  P := @Buf;
  kvVarWord32EncodeBuf(L, P^, N);
  Inc(P, N);
  if L > 0 then
    Move(FValue[0], P^, L);
  Result := M;
end;

function TkvBinaryValue.PutSerialBuf(const Buf; const BufSize: Integer): Integer;
var
  P : PByte;
  L : Integer;
  N : Integer;
  Len : Word32;
  M : Int32;
  S : kvByteArray;
begin
  P := @Buf;
  L := BufSize;

  N := kvVarWord32DecodeBuf(P^, L, Len);
  Dec(L, N);
  Inc(P, N);
  if Int32(Len) < 0 then
    raise EkvValue.Create('Invalid buffer: string length');

  M := Int32(Len);
  if L < M then
    raise EkvValue.Create(SInvalidBufferSize);
  Dec(L, M);
  SetLength(S, Len);
  if Len > 0 then
    Move(P^, S[0], M);
  FValue := S;

  Result := BufSize - L;
end;



{ TkvNullValue }

function TkvNullValue.Duplicate: AkvValue;
begin
  Result := TkvNullValue.Create;
end;

function TkvNullValue.GetAsString: String;
begin
  Result := 'null';
end;

function TkvNullValue.GetTypeId: Byte;
begin
  Result := KV_Value_TypeId_Null;
end;

function TkvNullValue.GetSerialSize: Integer;
begin
  Result := 0;
end;

function TkvNullValue.GetSerialBuf(var Buf; const BufSize: Integer): Integer;
begin
  Result := 0;
end;

function TkvNullValue.PutSerialBuf(const Buf; const BufSize: Integer): Integer;
begin
  Result := 0;
end;



{ TkvListValue }

destructor TkvListValue.Destroy;
var
  I : Integer;
begin
  for I := Length(FValue) - 1 downto 0 do
    FreeAndNil(FValue[I]);
  inherited Destroy;
end;

function TkvListValue.GetCount: Integer;
begin
  Result := Length(FValue);
end;

function TkvListValue.Duplicate: AkvValue;
var
  R : TkvListValue;
  I : Integer;
begin
  R := TkvListValue.Create;
  for I := 0 to Length(FValue) - 1 do
    R.Add(FValue[I].Duplicate);
  Result := R;
end;

function TkvListValue.GetAsString: String;
var
  S : String;
  I : Integer;
begin
  S := '[';
  for I := 0 to Length(FValue) - 1 do
    begin
      if I > 0 then
        S := S + ',';
      S := S + FValue[I].GetAsScript;
    end;
  S := S + ']';
  Result := S;
end;

function TkvListValue.GetTypeId: Byte;
begin
  Result := KV_Value_TypeId_List;
end;

function TkvListValue.GetSerialSize: Integer;
var
  L : Integer;
  R : Integer;
  I : Integer;
begin
  L := Length(FValue);
  R := kvVarWord32EncodedSize(L);
  for I := 0 to L - 1 do
    Inc(R, 1 + FValue[I].GetSerialSize);
  Result := R;
end;

function TkvListValue.GetSerialBuf(var Buf; const BufSize: Integer): Integer;
var
  P : PByte;
  L : Integer;
  M : Int32;
  F : Integer;
  I : Integer;
  V : AkvValue;
  N : Integer;
begin
  P := @Buf;
  L := BufSize;
  M := Length(FValue);
  F := kvVarWord32EncodeBuf(M, P^, L);
  Inc(P, F);
  Dec(L, F);
  for I := 0 to M - 1 do
    begin
      V := FValue[I];
      if L < 1 then
        raise EkvValue.Create(SInvalidBufferSize);
      P^ := V.GetTypeId;
      Inc(P);
      Dec(L);
      N := V.GetSerialBuf(P^, L);
      Inc(P, N);
      Dec(L, N);
    end;
  Result := BufSize - L;
end;

function TkvListValue.PutSerialBuf(const Buf; const BufSize: Integer): Integer;
var
  P : PByte;
  L : Integer;
  F : Integer;
  N : Integer;
  Cnt : Word32;
  I : Integer;
  TypId : Byte;
  Val : AkvValue;
begin
  P := @Buf;
  L := BufSize;
  F := kvVarWord32DecodeBuf(P^, L, Cnt);
  if Int32(Cnt) < 0 then
    raise EKvValue.Create('Invalid buffer: List count invalid');
  Inc(P, F);
  Dec(L, F);

  SetLength(FValue, Cnt);
  for I := 0 to Int32(Cnt) - 1 do
    begin
      if L < 1 then
        raise EkvValue.Create(SInvalidBufferSize);
      TypId := P^;
      Inc(P);
      Dec(L);

      Val := kvCreateValueFromTypeId(TypId);
      N := Val.PutSerialBuf(P^, L);
      Inc(P, N);
      Dec(L, N);

      FValue[I] := Val;
    end;

  Result := BufSize - L;
end;

procedure TkvListValue.Add(const Value: AkvValue);
var
  L : Integer;
begin
  L := Length(FValue);
  SetLength(FValue, L + 1);
  FValue[L] := Value;
end;

function TkvListValue.GetValue(const Index: Integer): AkvValue;
begin
  if (Index < 0) or (Index >= Length(FValue)) then
    raise EkvValue.Create('List index out of range');
  Result := FValue[Index];
end;

procedure TkvListValue.SetValue(const Index: Integer; const Value: AkvValue);
begin
  if (Index < 0) or (Index >= Length(FValue)) then
    raise EkvValue.Create('List index out of range');
  FValue[Index].Free;
  FValue[Index] := Value;
end;

procedure TkvListValue.DeleteValue(const Index: Integer);
var
  I, L : Integer;
begin
  L := Length(FValue);
  if (Index < 0) or (Index >= L) then
    raise EkvValue.Create('List index out of range');
  FValue[Index].Free;
  for I := Index to L - 2 do
    FValue[I] := FValue[I + 1];
  SetLength(FValue, L - 1);
end;

procedure TkvListValue.InsertValue(const Index: Integer; const Value: AkvValue);
var
  I, L : Integer;
begin
  L := Length(FValue);
  if (Index < 0) or (Index > L) then
    raise EkvValue.Create('List index out of range');
  SetLength(FValue, L + 1);
  for I := L downto Index + 1 do
    FValue[I] := FValue[I - 1];
  FValue[Index] := Value;
end;

procedure TkvListValue.AppendValue(const Value: AkvValue);
var
  L : Integer;
begin
  L := Length(FValue);
  SetLength(FValue, L + 1);
  FValue[L] := Value;
end;



{ TkvDictionaryValue }

destructor TkvDictionaryValue.Destroy;
var
  I : Integer;
begin
  for I := Length(FValue) - 1 downto 0 do
    FreeAndNil(FValue[I].Value);
  inherited Destroy;
end;

function TkvDictionaryValue.Duplicate: AkvValue;
var
  R : TkvDictionaryValue;
  I : Integer;
begin
  R := TkvDictionaryValue.Create;
  for I := 0 to Length(FValue) - 1 do
    R.Add(FValue[I].Key, FValue[I].Value.Duplicate);
  Result := R;
end;

function TkvDictionaryValue.GetAsString: String;
var
  S : String;
  I : Integer;
  V : PkvDictionaryKeyValuePair;
begin
  S := '{';
  for I := 0 to Length(FValue) - 1 do
    begin
      if I > 0 then
        S := S + ',';
      V := @FValue[I];
      S := S + V^.Key + ':' + V^.Value.GetAsScript;
    end;
  S := S + '}';
  Result := S;
end;

function TkvDictionaryValue.GetTypeId: Byte;
begin
  Result := KV_Value_TypeId_Dictionary;
end;

function TkvDictionaryValue.GetSerialSize: Integer;
var
  L : Integer;
  R : Integer;
  I : Integer;
  V : PkvDictionaryKeyValuePair;
  N : Integer;
  F : Integer;
begin
  L := Length(FValue);
  R := kvVarWord32EncodedSize(L);
  for I := 0 to L - 1 do
    begin
      V := @FValue[I];
      N := Length(V^.Key);
      F := kvVarWord32EncodedSize(N);
      Inc(R, F + N * SizeOf(Char) +
             1 + V^.Value.GetSerialSize);
    end;
  Result := R;
end;

function TkvDictionaryValue.GetSerialBuf(var Buf; const BufSize: Integer): Integer;
var
  P : PByte;
  L : Integer;
  M : Int32;
  F : Integer;
  I : Integer;
  V : PkvDictionaryKeyValuePair;
  N : Integer;
  T : Int32;
begin
  P := @Buf;
  L := BufSize;
  M := Length(FValue);
  F := kvVarWord32EncodeBuf(M, P^, L);
  Inc(P, F);
  Dec(L, F);
  for I := 0 to M - 1 do
    begin
      V := @FValue[I];
      T := Length(V^.Key);
      F := kvVarWord32EncodeBuf(T, P^, L);
      Inc(P, F);
      Dec(L, F);
      N := T * SizeOf(Char);
      if L < N then
        raise EkvValue.Create(SInvalidBufferSize);
      if T > 0 then
        Move(PChar(V^.Key)^, P^, N);
      Inc(P, N);
      Dec(L, N);
      if L < 1 then
        raise EkvValue.Create(SInvalidBufferSize);
      P^ := V^.Value.GetTypeId;
      Inc(P);
      Dec(L);
      N := V^.Value.GetSerialBuf(P^, L);
      Inc(P, N);
      Dec(L, N);
    end;
  Result := BufSize - L;
end;

function TkvDictionaryValue.PutSerialBuf(const Buf; const BufSize: Integer): Integer;
var
  P : PByte;
  L : Integer;
  N : Integer;
  F : Integer;
  Cnt : Word32;
  I : Integer;
  TypId : Byte;
  Val : AkvValue;
  KeyLen : Word32;
  Key : String;
  M : Integer;
  Pair : PkvDictionaryKeyValuePair;
begin
  P := @Buf;
  L := BufSize;
  F := kvVarWord32DecodeBuf(P^, L, Cnt);
  Inc(P, F);
  Dec(L, F);
  if Int32(Cnt) < 0 then
    raise EkvValue.Create('Invalid buffer: List count invalid');

  SetLength(FValue, Cnt);
  for I := 0 to Int32(Cnt) - 1 do
    begin
      F := kvVarWord32DecodeBuf(P^, L, KeyLen);
      Inc(P, F);
      Dec(L, F);
      if Int32(KeyLen) < 0 then
        raise EkvValue.Create('Invalid buffer: Key length invalid');

      M := KeyLen * SizeOf(Char);
      if L < M then
        raise EkvValue.Create(SInvalidBufferSize);
      SetLength(Key, KeyLen);
      if KeyLen > 0 then
        Move(P^, PChar(Key)^, M);
      Inc(P, M);
      Dec(L, M);

      if L < 1 then
        raise EkvValue.Create(SInvalidBufferSize);
      TypId := P^;
      Inc(P);
      Dec(L);

      Val := kvCreateValueFromTypeId(TypId);
      N := Val.PutSerialBuf(P^, L);
      Inc(P, N);
      Dec(L, N);

      Pair := @FValue[I];
      Pair^.Key := Key;
      Pair^.Value := Val;
    end;

  Result := BufSize - L;
end;

procedure TkvDictionaryValue.Add(const Key: String; const Value: AkvValue);
var
  L : Integer;
begin
  L := Length(FValue);
  SetLength(FValue, L + 1);
  FValue[L].Key := Key;
  FValue[L].Value := Value;
end;

procedure TkvDictionaryValue.AddString(const Key: String; const Value: String);
begin
  Add(Key, TkvStringValue.Create(Value));
end;

procedure TkvDictionaryValue.AddBoolean(const Key: String; const Value: Boolean);
begin
  Add(Key, TkvBooleanValue.Create(Value));
end;

procedure TkvDictionaryValue.AddFloat(const Key: String; const Value: Double);
begin
  Add(Key, TkvFloatValue.Create(Value));
end;

procedure TkvDictionaryValue.AddInteger(const Key: String; const Value: Int64);
begin
  Add(Key, TkvIntegerValue.Create(Value));
end;

procedure TkvDictionaryValue.AddDateTime(const Key: String; const Value: TDateTime);
begin
  Add(Key, TkvDateTimeValue.Create(Value));
end;

function TkvDictionaryValue.GetKeyIndex(const Key: String): Integer;
var
  I : Integer;
begin
  for I := 0 to Length(FValue) - 1 do
    if SameText(FValue[I].Key, Key) then
      begin
        Result := I;
        exit;
      end;
  Result := -1;
end;

function TkvDictionaryValue.Exists(const Key: String): Boolean;
begin
  Result := GetKeyIndex(Key) >= 0;
end;

function TkvDictionaryValue.GetValue(const Key: String): AkvValue;
var
  I : Integer;
begin
  I := GetKeyIndex(Key);
  if I < 0 then
    raise EkvValue.CreateFmt('Dictionary key not found: %s', [Key]);
  Result := FValue[I].Value;
end;

function TkvDictionaryValue.GetValueAsString(const Key: String): String;
begin
  Result := GetValue(Key).AsString;
end;

function TkvDictionaryValue.GetValueAsBoolean(const Key: String): Boolean;
begin
  Result := GetValue(Key).AsBoolean;
end;

function TkvDictionaryValue.GetValueAsFloat(const Key: String): Double;
begin
  Result := GetValue(Key).AsFloat;
end;

function TkvDictionaryValue.GetValueAsInteger(const Key: String): Int64;
begin
  Result := GetValue(Key).AsInteger;
end;

function TkvDictionaryValue.GetValueAsDateTime(const Key: String): TDateTime;
begin
  Result := GetValue(Key).AsDateTime;
end;

procedure TkvDictionaryValue.SetValue(const Key: String; const Value: AkvValue);
var
  I : Integer;
begin
  I := GetKeyIndex(Key);
  if I < 0 then
    raise EkvValue.CreateFmt('Dictionary key not found: %s', [Key]);
  FValue[I].Value.Free;
  FValue[I].Value := Value;
end;

procedure TkvDictionaryValue.SetValueString(const Key: String; const Value: String);
begin
  SetValue(Key, TkvStringValue.Create(Value));
end;

procedure TkvDictionaryValue.SetValueInteger(const Key: String; const Value: Int64);
begin
  SetValue(Key, TkvIntegerValue.Create(Value));
end;

procedure TkvDictionaryValue.SetValueDateTime(const Key: String; const Value: TDateTime);
begin
  SetValue(Key, TkvDateTimeValue.Create(Value));
end;

procedure TkvDictionaryValue.DeleteValue(const Key: String);
var
  I, L, J : Integer;
begin
  I := GetKeyIndex(Key);
  if I < 0 then
    raise EkvValue.CreateFmt('Dictionary key not found: %s', [Key]);
  FValue[I].Value.Free;
  L := Length(FValue);
  for J := I to L - 2 do
    FValue[J] := FValue[J + 1];
  SetLength(FValue, L - 1);
end;

function TkvDictionaryValue.GetCount: Integer;
begin
  Result := Length(FValue);
end;

function TkvDictionaryValue.GetItem(const Idx: Integer): PkvDictionaryKeyValuePair;
begin
  Assert(Idx >= 0);
  Assert(Idx < Length(FValue));

  Result := @FValue[Idx];
end;



{ kvByteArray helpers }

function kvByteArrayAppend(const A, B: kvByteArray): kvByteArray;
var
  L1 : Integer;
  L2 : Integer;
  L : Integer;
  R : kvByteArray;
begin
  L1 := Length(A);
  L2 := Length(B);
  L := L1 + L2;
  SetLength(R, L);
  if L1 > 0 then
    Move(A[0], R[0], L1);
  if L2 > 0 then
    Move(B[0], R[L1], L2);
  Result := R;
end;

function kvByteArrayCompare(const A, B: kvByteArray): Integer;
var
  L1 : Integer;
  L2 : Integer;
  I : Integer;
  F, G : Byte;
begin
  L1 := Length(A);
  L2 := Length(B);
  if L1 < L2 then
    Result := -1
  else
  if L1 > L2 then
    Result := 1
  else
    begin
      for I := 0 to L1 - 1 do
        begin
          F := A[I];
          G := B[I];
          if F < G then
            begin
              Result := -1;
              exit;
            end
          else
          if F > G then
            begin
              Result := 1;
              exit;
            end;
        end;
      Result := 0;
    end;
end;



{ Value operators }

function ValueOpPlus(const A, B: AkvValue): AkvValue;
begin
  if (A is TkvNullValue) or (B is TkvNullValue) then
    Result := TkvNullValue.Create
  else
  if (A is TkvBinaryValue) or (B is TkvBinaryValue) then
    Result := TkvBinaryValue.Create(kvByteArrayAppend(A.GetAsBinary, B.GetAsBinary))
  else
  if (A is TkvStringValue) or (B is TkvStringValue) then
    Result := TkvStringValue.Create(A.GetAsString + B.GetAsString)
  else
  if (A is TkvFloatValue) or (B is TkvFloatValue) then
    Result := TkvFloatValue.Create(A.GetAsFloat + B.GetAsFloat)
  else
  if (A is TkvIntegerValue) or (B is TkvIntegerValue) then
    Result := TkvIntegerValue.Create(A.GetAsInteger + B.GetAsInteger)
  else
    raise EkvValue.CreateFmt('Type error: Cannot add types: %s and %s',
        [A.ClassName, B.ClassName]);
end;

function ValueOpMinus(const A, B: AkvValue): AkvValue;
begin
  if (A is TkvNullValue) or (B is TkvNullValue) then
    Result := TkvNullValue.Create
  else
  if (A is TkvFloatValue) or (B is TkvFloatValue) then
    Result := TkvFloatValue.Create(A.GetAsFloat - B.GetAsFloat)
  else
  if (A is TkvIntegerValue) or (B is TkvIntegerValue) then
    Result := TkvIntegerValue.Create(A.GetAsInteger - B.GetAsInteger)
  else
    raise EkvValue.CreateFmt('Type error: Cannot subtract types: %s and %s',
        [A.ClassName, B.ClassName]);
end;

function ValueOpMultiply(const A, B: AkvValue): AkvValue;
begin
  if (A is TkvNullValue) or (B is TkvNullValue) then
    Result := TkvNullValue.Create
  else
  if (A is TkvFloatValue) or (B is TkvFloatValue) then
    Result := TkvFloatValue.Create(A.GetAsFloat * B.GetAsFloat)
  else
  if (A is TkvIntegerValue) or (B is TkvIntegerValue) then
    Result := TkvIntegerValue.Create(A.GetAsInteger * B.GetAsInteger)
  else
    raise EkvValue.CreateFmt('Type error: Cannot multiply types: %s and %s',
        [A.ClassName, B.ClassName]);
end;

function ValueOpDivide(const A, B: AkvValue): AkvValue;
begin
  if (A is TkvNullValue) or (B is TkvNullValue) then
    Result := TkvNullValue.Create
  else
  if (A is TkvFloatValue) or (B is TkvFloatValue) then
    Result := TkvFloatValue.Create(A.GetAsFloat / B.GetAsFloat)
  else
  if (A is TkvIntegerValue) or (B is TkvIntegerValue) then
    Result := TkvFloatValue.Create(A.GetAsInteger / B.GetAsInteger)
  else
    raise EkvValue.CreateFmt('Type error: Cannot divide types: %s and %s',
        [A.ClassName, B.ClassName]);
end;

function ValueOpOR(const A, B: AkvValue): AkvValue;
begin
  if (A is TkvNullValue) or (B is TkvNullValue) then
    Result := TkvNullValue.Create
  else
  if (A is TkvBooleanValue) or (B is TkvBooleanValue) then
    Result := TkvBooleanValue.Create(A.GetAsBoolean or B.GetAsBoolean)
  else
  if (A is TkvIntegerValue) or (B is TkvIntegerValue) then
    Result := TkvIntegerValue.Create(A.GetAsInteger or B.GetAsInteger)
  else
    raise EkvValue.CreateFmt('Type error: Cannot OR types: %s and %s',
        [A.ClassName, B.ClassName]);
end;

function ValueOpXOR(const A, B: AkvValue): AkvValue;
begin
  if (A is TkvNullValue) or (B is TkvNullValue) then
    Result := TkvNullValue.Create
  else
  if (A is TkvBooleanValue) or (B is TkvBooleanValue) then
    Result := TkvBooleanValue.Create(A.GetAsBoolean xor B.GetAsBoolean)
  else
  if (A is TkvIntegerValue) or (B is TkvIntegerValue) then
    Result := TkvIntegerValue.Create(A.GetAsInteger xor B.GetAsInteger)
  else
    raise EkvValue.CreateFmt('Type error: Cannot XOR types: %s and %s',
        [A.ClassName, B.ClassName]);
end;

function ValueOpAND(const A, B: AkvValue): AkvValue;
begin
  if (A is TkvNullValue) or (B is TkvNullValue) then
    Result := TkvNullValue.Create
  else
  if (A is TkvBooleanValue) or (B is TkvBooleanValue) then
    Result := TkvBooleanValue.Create(A.GetAsBoolean and B.GetAsBoolean)
  else
  if (A is TkvIntegerValue) or (B is TkvIntegerValue) then
    Result := TkvIntegerValue.Create(A.GetAsInteger and B.GetAsInteger)
  else
    raise EkvValue.CreateFmt('Type error: Cannot AND types: %s and %s',
        [A.ClassName, B.ClassName]);
end;

function ValueOpNOT(const A: AkvValue): AkvValue;
begin
  if A is TkvNullValue then
    Result := TkvNullValue.Create
  else
  if A is TkvBooleanValue then
    Result := TkvBooleanValue.Create(not A.GetAsBoolean)
  else
  if A is TkvIntegerValue then
    Result := TkvIntegerValue.Create(not A.GetAsInteger)
  else
    raise EkvValue.CreateFmt('Type error: Cannot NOT type: %s', [A.ClassName]);
end;

function CompareFloat(const A, B: Double): Integer;
begin
  if A < B then
    Result := -1
  else
  if A > B then
    Result := 1
  else
    Result := 0;
end;

function CompareInt(const A, B: Int64): Integer;
begin
  if A < B then
    Result := -1
  else
  if A > B then
    Result := 1
  else
    Result := 0;
end;

function CompareDateTime(const A, B: TDateTime): Integer;
begin
  if A < B then
    Result := -1
  else
  if A > B then
    Result := 1
  else
    Result := 0;
end;

function ValueOpCompare(const A, B: AkvValue): Integer;
begin
  if (A is TkvNullValue) and (B is TkvNullValue) then
    Result := 0
  else
  if A is TkvNullValue then
    Result := -1
  else
  if B is TkvNullValue then
    Result := 1
  else
  if (A is TkvBinaryValue) or (B is TkvBinaryValue) then
    Result := kvByteArrayCompare(A.GetAsBinary, B.GetAsBinary)
  else
  if (A is TkvBooleanValue) or (B is TkvBooleanValue) then
    Result := CompareInt(Ord(A.GetAsBoolean), Ord(B.GetAsBoolean))
  else
  if (A is TkvDateTimeValue) or (B is TkvDateTimeValue) then
    Result := CompareDateTime(A.AsDateTime, B.AsDateTime)
  else
  if (A is TkvStringValue) or (B is TkvStringValue) then
    Result := CompareStr(A.GetAsString, B.GetAsString)
  else
  if (A is TkvFloatValue) or (B is TkvFloatValue) then
    Result := CompareFloat(A.GetAsFloat, B.GetAsFloat)
  else
  if (A is TkvIntegerValue) or (B is TkvIntegerValue) then
    Result := CompareInt(A.GetAsInteger, B.GetAsInteger)
  else
    raise EkvValue.CreateFmt('Type error: Cannot compare types: %s and %s',
        [A.ClassName, B.ClassName]);
end;



end.
