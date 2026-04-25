USE Bookstore_DWH;
GO
-- ============================================================
-- 1. dim_date
-- ============================================================
CREATE TABLE dwh.dim_date (
    date_sk      INT         NOT NULL PRIMARY KEY,
    full_date    DATE        NOT NULL,
    day_of_week  TINYINT     NOT NULL,
    day_name     VARCHAR(10) NOT NULL,
    month        TINYINT     NOT NULL,
    month_name   VARCHAR(10) NOT NULL,
    quarter      TINYINT     NOT NULL,
    year         SMALLINT    NOT NULL,
    is_weekend   BIT         NOT NULL DEFAULT 0
);
GO

-- ============================================================
-- 2. dim_book  (SCD Type 2)
-- ============================================================
CREATE TABLE dwh.dim_book (
    book_sk          INT IDENTITY(1,1) PRIMARY KEY,
    book_bk          INT          NOT NULL,   -- NK
    title            VARCHAR(400) NOT NULL,
    isbn13           VARCHAR(20)  NULL,
    language_code    VARCHAR(10)  NULL,
    language_name    VARCHAR(100) NULL,
    num_pages        INT          NULL,
    publication_date DATE         NULL,
    publisher_id     INT          NULL,
    publisher_name   VARCHAR(200) NULL,
    -- SCD2
    is_current       BIT          NOT NULL DEFAULT 1,
    valid_from       DATE         NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    valid_to         DATE         NOT NULL DEFAULT '9999-12-31'
);
GO

-- ============================================================
-- 3. dim_author
-- ============================================================
CREATE TABLE dwh.dim_author (
    author_sk   INT IDENTITY(1,1) PRIMARY KEY,
    author_bk   INT          NOT NULL,        -- NK
    author_name VARCHAR(200) NOT NULL
);
GO

-- ============================================================
-- 4. bridge_book_author
-- ============================================================
CREATE TABLE dwh.bridge_book_author (
    book_sk_fk   INT NOT NULL,
    author_sk_fk INT NOT NULL,
    PRIMARY KEY (book_sk_fk, author_sk_fk),
    FOREIGN KEY (book_sk_fk)   REFERENCES dwh.dim_book   (book_sk),
    FOREIGN KEY (author_sk_fk) REFERENCES dwh.dim_author (author_sk)
);
GO

-- ============================================================
-- 5. dim_customer  (SCD Type 2)
-- ============================================================
CREATE TABLE dwh.dim_customer (
    customer_sk INT IDENTITY(1,1) PRIMARY KEY,
    customer_bk INT          NOT NULL,        -- NK
    first_name  VARCHAR(100) NOT NULL,
    last_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(200) NULL,
    -- SCD2
    is_current  BIT          NOT NULL DEFAULT 1,
    valid_from  DATE         NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    valid_to    DATE         NOT NULL DEFAULT '9999-12-31'
);
GO

-- ============================================================
-- 6. dim_address
-- ============================================================
CREATE TABLE dwh.dim_address (
    dest_address_sk INT IDENTITY(1,1) PRIMARY KEY,
    address_id      INT          NOT NULL,    -- NK
    street_number   VARCHAR(20)  NULL,
    street_name     VARCHAR(200) NULL,
    city            VARCHAR(100) NULL,
    country_id      INT          NULL,
    country_name    VARCHAR(100) NULL
);
GO

-- ============================================================
-- 7. dim_status_history
-- ============================================================
CREATE TABLE dwh.dim_status_history (
    status_history_sk    INT IDENTITY(1,1) PRIMARY KEY,
    order_bk             INT           NOT NULL,   -- NK
    order_status_bk      INT           NOT NULL,
    order_status_value   VARCHAR(100)  NOT NULL,
    status_date          DATE          NOT NULL,
    shipping_method_bk   INT           NULL,
    shipping_method_name VARCHAR(100)  NULL,
    shipping_cost        DECIMAL(10,2) NULL
);
GO

-- ============================================================
-- 8. fact_sales
-- ============================================================
CREATE TABLE dwh.fact_sales (
    fact_sk                 INT IDENTITY(1,1) PRIMARY KEY,
    -- Foreign Keys
    date_sk_fk              INT           NOT NULL,
    book_sk_fk              INT           NOT NULL,
    customer_sk_fk          INT           NOT NULL,
    dest_address_sk_fk      INT           NOT NULL,
    status_history_sk_fk    INT           NOT NULL,
    -- Degenerate Dimensions
    order_id                INT           NOT NULL,   -- DD
    line_id                 INT           NOT NULL,   -- DD
    -- Measures
    price                   DECIMAL(10,2) NOT NULL,
    shipping_cost_allocated DECIMAL(10,2) NULL,

    FOREIGN KEY (date_sk_fk)           REFERENCES dwh.dim_date           (date_sk),
    FOREIGN KEY (book_sk_fk)           REFERENCES dwh.dim_book           (book_sk),
    FOREIGN KEY (customer_sk_fk)       REFERENCES dwh.dim_customer       (customer_sk),
    FOREIGN KEY (dest_address_sk_fk)   REFERENCES dwh.dim_address        (dest_address_sk),
    FOREIGN KEY (status_history_sk_fk) REFERENCES dwh.dim_status_history (status_history_sk)
);
GO
