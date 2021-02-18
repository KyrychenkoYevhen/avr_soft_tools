unit Errors;

interface

const
   ER_SYNTAX            = '������ ����������';

   ER_FUNC_ARGS         = '������ ������ ���������� %s: ';
   ER_FUNC_ARGS_OPEN    = ER_FUNC_ARGS + '��������� ������ (';
   ER_FUNC_ARGS_CLOSE   = ER_FUNC_ARGS + '��������� ������ )';
   ER_FUNC_ARGS_INVALID = ER_FUNC_ARGS + '��������� ���������� ��� ���������';
   ER_FUNC_ARGS_SYNTAX  = ER_FUNC_ARGS + '�������������� ������';
   ER_FUNC_ARGS_COUNT   = ER_FUNC_ARGS + '�������� ����������. ��������� ����������: %d';

   ER_FOR               = '������ ��������� for: ';
   ER_FOR_EXP_EXISTS    =  ER_FOR + '��������� ���������';
   ER_FOR_VAR_LOC       =  ER_FOR + '��������� ��� ��������� ����������';

   ER_LEX_NOT_FOUND     = '������� %s �� �������';
   ER_SYMBOL_EXISTS     = '��������� ������ %s';

   ER_OBJ_FIELD_ACCESS  = '������ ������� � ����� ������� %s: ��������� �������� .';
   ER_OBJ_METHOD_BAD    = '����� %s ��� ������� %s �� ��������������';

   ER_VAR_EXISTS        = '���������� � ������ %s ��� ����������';
   ER_VAR_NOT_FOUND     = '���������� � ������ %s �� �������';

   ER_TOK_DNT_SUP       = '������ � ����� 0x%s � ������� %d �� ��������������';

implementation

end.
