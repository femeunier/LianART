function QSM = ConvertQSM(rawdata)

% Conversion to QSM blocks
Sta = [rawdata(:,3),rawdata(:,4),rawdata(:,5)];
Axe = [rawdata(:,6),rawdata(:,7),rawdata(:,8)];
Len = rawdata(:,2);
Rad = rawdata(:,1);
Par = rawdata(:,9);
BI = rawdata(:,12);

Added = [];

QSM = QSMBCylindrical(Sta,Axe,Len,Rad,Par,BI,Added);

end