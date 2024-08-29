def validate_df_set(dfs: Dict[str, DataFrame]) -> None:
    """Validate dataframes"""
    for name, df in dfs.items():
        print(f"Validating dataframe: {name}")
        df.printSchema()
        df.show(5)
        print(f"Dataframe: {name} validated")