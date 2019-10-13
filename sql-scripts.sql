/******** drop all tables ********/
drop table if exists `todelete_observation`;
drop table if exists `acceleration_observation`;
drop table if exists `temperature_observation`;
drop table if exists `signal_strength_observation`;
drop table if exists `occupancy_observation`;
drop table if exists `test_observation`;
/******************************************/
drop table if exists `physical_sensor`;
drop table if exists `virtual_sensor`;
drop table if exists `actuator`;
drop table if exists `physical_sensor`;
drop table if exists `virtual_sensor`;
drop table if exists `device`;
drop table if exists `actuatable_property`;
drop table if exists `observable_property`;
drop table if exists `static_property`;
drop table if exists `actuation_type`;
drop table if exists `observation_type`;
drop table if exists `entity_type_property`;
drop table if exists `property`;
drop table if exists `property_class`;
drop table if exists `space`;
drop table if exists `person`;
drop table if exists `entity`;
drop table if exists `entity_type`;
drop table if exists `entity_class`;
drop table if exists `device_type`;
drop table if exists `device_class`;

/*********************************************************************/

create table entity_class (
  `id`     int primary key not null auto_increment,
  `name`   varchar(50) not null
);

create table entity_type (
  `id`             int primary key not null auto_increment,
  `name`           varchar(50) not null,
  `entityClassId`  int not null,
  `subtypeOf`      int null,
  foreign key (`entityClassId`) references `entity_class`(`id`)
    on update cascade,
  foreign key (`subtypeOf`) references `entity_type`(`id`)
    on update cascade
);

create table entity (
  `id`           int primary key not null auto_increment,
  `name`         varchar(50) not null,
  `entityTypeId` int not null,
  foreign key (`entityTypeId`) references `entity_type`(`id`)
    on update cascade
);

create table person (
  `id`     int primary key not null,
    /* might contain more attributes */
  foreign key (`id`) references `entity`(`id`)
    on update cascade on delete cascade
);

create table space (
  `id`     int primary key not null,
  `extent` varchar(50),  /* placeholder */
  foreign key (`id`) references `entity`(`id`)
    on update cascade on delete cascade
);

/**************************************/

create table property_class (
  `id`     int primary key not null auto_increment,
  `name`   varchar(50) not null
);

create table property (
  `id`              int primary key not null auto_increment,
  `name`            varchar(50) not null,
  `propertyClassId` int not null,
  foreign key (`propertyClassId`) references `property_class`(`id`)
    on update cascade on delete cascade
);

create table entity_type_property (
  `entityTypeId`  int not null,
  `propertyId`    int not null,
  primary key (`entityTypeId`, `propertyId`),
  foreign key (`entityTypeId`) references `entity_type`(`id`)
    on update cascade on delete cascade,
  foreign key (`propertyId`) references `property`(`id`)
    on update cascade on delete cascade
);

create table observation_type (
  `id`         int primary key not null auto_increment,
  `name`       varchar(50) not null,
  `tableName`  varchar(50) not null,
  `isSemantic` boolean not null
);

create table actuation_type (
  `id`        int primary key not null auto_increment,
  `name`      varchar(50) not null
);

create table static_property (
  `id`        int primary key not null,
  `value`     varchar(50),
  foreign key (`id`) references `property`(`id`)
    on update cascade on delete cascade
);

create table observable_property (
  `id`        int primary key not null,
  `obsTypeId` int not null,
  foreign key (`id`) references `property`(`id`)
    on update cascade on delete cascade,
  foreign key (`obsTypeId`) references `observation_type`(`id`)
    on update cascade on delete cascade
);

create table actuatable_property (
  `id`        int primary key not null,
  `actTypeId` int not null,
  foreign key (`id`) references `property`(`id`)
    on update cascade on delete cascade,
  foreign key (`actTypeId`) references `actuation_type`(`id`)
    on update cascade on delete cascade
);


/*********************************************/

create table device_class (
  `id`     int primary key not null auto_increment,
  `name`   varchar(50) not null
);

create table device_type (
  `id`            int primary key not null auto_increment,
  `name`          varchar(50) not null,
  `deviceClassId` int not null,
  foreign key (`deviceClassId`) references `device_class`(`id`)
    on update cascade on delete cascade
);

create table device (
  `id`           int primary key not null auto_increment,
  `name`         varchar(50) not null,
  `deviceTypeId` int not null,
  foreign key (`deviceTypeId`) references `device_type`(`id`)
    on update cascade
);

create table physical_sensor (
  `id`   int primary key not null auto_increment,
  foreign key (`id`) references `device`(`id`)
    on update cascade on delete cascade
);

create table virtual_sensor (
  `id`   int primary key not null auto_increment,
  foreign key (`id`) references `device`(`id`)
    on update cascade on delete cascade
);

create table actuator (
  `id`   int primary key not null auto_increment,
  foreign key (`id`) references `device`(`id`)
    on update cascade on delete cascade
);


/******** required queries ********/

insert into `entity_class`(`name`) values
  ('person'), ('space');

insert into `property_class`(`name`) values
  ('static'), ('observable'), ('actuatable');

insert into `device_class`(`name`) values
  ('physical_sensor'), ('virtual_sensor'), ('actuator');